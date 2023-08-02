
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Increase of the errors/second rate for Tomcat server
---

This incident type refers to an increase in the number of errors per second on a Tomcat server, which could indicate an issue with the server itself, the host, a deployed application, or an application servlet. This could include errors generated when the Tomcat server runs out of memory, can't find a requested file or servlet, or is unable to serve a JSP due to syntax errors in the servlet codebase. This incident type requires immediate attention to diagnose and address the underlying issue.

### Parameters
```shell
# Environment Variables
export TOMCAT_APP="PLACEHOLDER"
export NAMESPACE="PLACEHOLDER"
export TOMCAT_CONTAINER_NAME="PLACEHOLDER"
export TOMCAT_POD_NAME="PLACEHOLDER"
export NODE_NAME="PLACEHOLDER"
export CPU_THRESHOLD="PLACEHOLDER"
export MEMORY_THRESHOLD="PLACEHOLDER"
export TOMCAT_CONFIG_FILE="PLACEHOLDER"
export EXPECTED_TOMCAT_SETTINGS="PLACEHOLDER"
export SERVICE_NAME="PLACEHOLDER"
export DEPLOYMENT_NAME="PLACEHOLDER"
export SERVICE_IP="PLACEHOLDER"
export PORT="PLACEHOLDER"
```

## Debug

### Check the status of the Tomcat pod
```shell
kubectl get pods -n ${NAMESPACE} -l app=${TOMCAT_APP}
```

### Check the logs of the Tomcat container for any errors
```shell
kubectl logs -n ${NAMESPACE} ${TOMCAT_POD_NAME} -c ${TOMCAT_CONTAINER_NAME}
```

### Check the CPU and memory usage of the Tomcat container
```shell
kubectl top pod -n ${NAMESPACE} ${TOMCAT_POD_NAME}
```

### Check the network traffic of the Tomcat container
```shell
kubectl exec -n ${NAMESPACE} ${TOMCAT_POD_NAME} -c ${TOMCAT_CONTAINER_NAME} -- netstat -na
```

### Check the health of the Kubernetes cluster nodes where the Tomcat pod is running
```shell
kubectl describe node ${NODE_NAME}
```

### Check the status of the Kubernetes services and endpoints
```shell
kubectl get svc,ep -n ${NAMESPACE}
```

### Check the status of the Kubernetes ingress controller
```shell
kubectl get ingress -n ${NAMESPACE}
```

### The host machine running the Tomcat server is experiencing high CPU or memory usage, causing the server to become unresponsive and generate errors.
```shell
bash
#!/bin/bash

# Set variables
NODE_NAME=${NODE_NAME}
POD_NAME=${POD_NAME}
CONTAINER_NAME=${CONTAINER_NAME}
THRESHOLD_CPU=${CPU_THRESHOLD}
THRESHOLD_MEMORY=${MEMORY_THRESHOLD}

# Get CPU and memory usage for node
CPU_USAGE=$(kubectl top node $NODE_NAME | awk '{print $2}' | tail -n 1)
MEMORY_USAGE=$(kubectl top node $NODE_NAME | awk '{print $3}' | tail -n 1)

# Check if CPU or memory usage exceeds threshold
if (( $(echo "$CPU_USAGE > $THRESHOLD_CPU" | bc -l) )) || (( $(echo "$MEMORY_USAGE > $THRESHOLD_MEMORY" | bc -l) )); then
  # Get logs from Tomcat container
  kubectl logs $POD_NAME $CONTAINER_NAME > tomcat_logs.txt
  echo "Tomcat logs saved to tomcat_logs.txt"
else
  echo "CPU and memory usage are below threshold"
fi

```

### A software update or configuration change was made to the Tomcat server that caused it to malfunction and produce errors.
```shell

#!/bin/bash

# This script diagnoses a scenario where a software update or configuration change caused a Tomcat server to malfunction and produce errors

# 1. Check if there were any recent software updates or configuration changes made to the Tomcat server
recent_changes=$(kubectl get pods ${TOMCAT_POD_NAME} -o jsonpath='{.metadata.annotations.kubernetes\.io/change-cause}')
if [ -n "$recent_changes" ]; then
  echo "Recent changes made to the Tomcat server:"
  echo "$recent_changes"
else
  echo "No recent changes made to the Tomcat server."
fi

# 2. Check the logs of the Tomcat server for any error messages
error_logs=$(kubectl logs ${TOMCAT_POD_NAME} | grep ERROR)
if [ -n "$error_logs" ]; then
  echo "Error logs found in the Tomcat server logs:"
  echo "$error_logs"
else
  echo "No error logs found in the Tomcat server logs."
fi

# 3. Check if the Tomcat server is running with the expected configuration settings
expected_settings="${EXPECTED_TOMCAT_SETTINGS}"
current_settings=$(kubectl exec ${TOMCAT_POD_NAME} -- cat ${TOMCAT_CONFIG_FILE})
if [ "$current_settings" != "$expected_settings" ]; then
  echo "Tomcat server is not running with the expected configuration settings."
  echo "Current settings:"
  echo "$current_settings"
  echo "Expected settings:"
  echo "$expected_settings"
else
  echo "Tomcat server is running with the expected configuration settings."
fi

# 4. Check the system resources of the host machine running the Tomcat server
resource_usage=$(kubectl top pod ${TOMCAT_POD_NAME})
echo "Resource usage for the Tomcat server:"
echo "$resource_usage"

```

---
### Diagnostics

* A software update or configuration change was made to the Tomcat server that caused it to malfunction and produce errors.

* The host machine running the Tomcat server is experiencing high CPU or memory usage, causing the server to become unresponsive and generate errors.

* A deployed application or application servlet on the Tomcat server is producing errors due to bugs or conflicts with other software components.

* The Tomcat server is under heavy load or is being attacked by malicious traffic, causing it to produce errors and become unresponsive.

* The Tomcat server is not properly configured or optimized for the workload it is handling, leading to performance issues and errors.

## Repair
---

### Check the server logs to determine the cause of the errors and identify any patterns or trends that may be contributing to the increase in errors.
```shell
bash
#!/bin/bash

# Get the Kubernetes pod name and container name for the Tomcat server
POD_NAME=${TOMCAT_POD_NAME}
CONTAINER_NAME=${TOMCAT_CONTAINER_NAME}

# Get the logs for the Tomcat container
kubectl logs $POD_NAME -c $CONTAINER_NAME > tomcat_logs.txt

# Search the logs for error messages and output them to a separate file
grep "ERROR" tomcat_logs.txt > tomcat_errors.txt

# Analyze the error messages to determine if there are any common patterns or trends
# that may be contributing to the increase in errors

# If necessary, check the Kubernetes events to see if there are any issues with the
# Kubernetes cluster that may be affecting the Tomcat server
kubectl get events > kubernetes_events.txt

```

### Check the deployed application to ensure that it is functioning correctly and that there are no coding errors or configuration issues.
```shell
bash
#!/bin/bash

# Check that kubectl is installed
if ! command -v kubectl &> /dev/null
then
    echo "kubectl could not be found"
    exit 1
fi

# Check that the application is deployed
if [[ $(kubectl get deployments/${DEPLOYMENT_NAME} -o jsonpath='{.status.readyReplicas}') -ne 1 ]]
then
    echo "The application deployment is not running or ready"
    exit 1
fi

# Check that the application service is running
if [[ $(kubectl get services/${SERVICE_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].ip}') == "" ]]
then
    echo "The application service is not running or ready"
    exit 1
fi

# Check that the application responds to requests
if [[ $(curl -s -o /dev/null -w "%{http_code}" http://${SERVICE_IP}:${PORT}/health) -ne 200 ]]
then
    echo "The application is not responding to requests"
    exit 1
fi

echo "The deployed application is functioning correctly"
exit 0

```

---
### Remediations

* Check the server logs to determine the cause of the errors and identify any patterns or trends that may be contributing to the increase in errors.

* Verify that there is no issue with the host server, such as insufficient resources or network connectivity problems.

* Check the deployed application to ensure that it is functioning correctly and that there are no coding errors or configuration issues.

* If necessary, restart the Tomcat server to clear any cached data or memory leaks that may be causing the errors.

* Ensure that the latest version of Tomcat and any deployed applications are being used, as older versions may have known bugs or security vulnerabilities that could be contributing to the errors.

* Monitor the server and deployed applications going forward to detect any recurring issues and to prevent future incidents.