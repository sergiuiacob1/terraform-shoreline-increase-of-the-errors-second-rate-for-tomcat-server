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