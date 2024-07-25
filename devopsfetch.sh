#!/bin/bash

LOG_FILE="/var/log/devopsfetch.log"
# exec >> "$LOG_FILE" 2>&1

# Function to display all active ports and services
function show_ports {
  if [ -z "$1" ]; then
    sudo netstat -tuln
  else
    sudo netstat -tuln | grep ":$1"
  fi
}

# Function to list all Docker images and containers
function show_docker {
  if [ -z "$1" ]; then
    echo "Docker Images:"
    docker images
    echo ""
    echo "Docker Containers:"
    docker ps -a
  else
    docker inspect "$1"
  fi
}

# Function to display all Nginx domains, proxies, and configuration files in table format
function show_nginx {
  if [ -z "$1" ]; then
    sudo nginx -T | awk '
      BEGIN {
        print "Domain\tProxy\tConfiguration File";
        RS="}";
        FS="\n"
      }
      /server_name/ {
        domain="";
        proxy="";
        conf_file="";
        for(i=1; i<=NF; i++) {
          if ($i ~ /server_name/) {
            split($i, arr, " ");
            domain=arr[2];
          }
          if ($i ~ /proxy_pass/) {
            split($i, arr, " ");
            proxy=arr[2];
          }
          if ($i ~ /# configuration file/) {
            split($i, arr, " ");
            conf_file=arr[4];
          }
        }
        if (domain) {
          print domain "\t" proxy "\t" conf_file;
        }
      }' | column -t -s $'\t'
  else
    sudo nginx -T | awk -v domain="$1" '
      BEGIN {
        print "Domain\tProxy\tConfiguration File";
        RS="}";
        FS="\n"
      }
      /server_name/ && $0 ~ domain {
        for(i=1; i<=NF; i++) {
          if ($i ~ /server_name/) {
            split($i, arr, " ");
            domain=arr[2];
          }
          if ($i ~ /proxy_pass/) {
            split($i, arr, " ");
            proxy=arr[2];
          }
          if ($i ~ /# configuration file/) {
            split($i, arr, " ");
            conf_file=arr[4];
          }
        }
        print domain "\t" proxy "\t" conf_file;
      }' | column -t -s $'\t'
  fi
}

# Function to list all users and their last login times
function show_users {
  if [ -z "$1" ]; then
    lastlog
  else
    last "$1"
  fi
}

# Function to display activities within a specified time range

function show_time_range {
  if [[ -z "$2" ]]; then
    sudo journalctl --since "$1" --until "$1 23:59:59"
  else
    sudo journalctl --since "$1" --until "$2"
  fi
}

# function show_time_range {
#   sudo journalctl --since "$1" --until "$2"
# }

# Display help message
function show_help {
  echo "Usage: devopsfetch [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -p, --port [PORT]        Display all active ports or details of a specific port"
  echo "  -d, --docker [CONTAINER] List all Docker images/containers or details of a specific container"
  echo "  -n, --nginx [DOMAIN]     Display all Nginx domains or details of a specific domain"
  echo "  -u, --users [USERNAME]   List all users or details of a specific user"
  echo "  -t, --time START END     Display activities within a specified time range"
  echo "  -h, --help               Show this help message"
}

# Main script logic
if [[ "$#" -eq 0 ]]; then
  echo "Error: No options provided. Use -h or --help for usage information."
  exit 1
fi

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -p|--port)
      if [[ "$#" -gt 1 && ! "$2" =~ ^- ]]; then
        show_ports "$2"
        shift 2
      else
        show_ports
        shift
      fi
      ;;
    -d|--docker)
      if [[ "$#" -gt 1 && ! "$2" =~ ^- ]]; then
        show_docker "$2"
        shift 2
      else
        show_docker
        shift
      fi
      ;;
    -n|--nginx)
      if [[ "$#" -gt 1 && ! "$2" =~ ^- ]]; then
        show_nginx "$2"
        shift 2
      else
        show_nginx
        shift
      fi
      ;;
    -u|--users)
      if [[ "$#" -gt 1 && ! "$2" =~ ^- ]]; then
        show_users "$2"
        shift 2
      else
        show_users
        shift
      fi
      ;;
    -t|--time)
      if [[ "$#" -gt 2 && ! "$2" =~ ^- && ! "$3" =~ ^- ]]; then
        show_time_range "$2" "$3"
        shift 3
      else
        echo "Error: --time requires a start and end time."
        exit 1
      fi
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done
