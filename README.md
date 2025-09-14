# GitHub Actions Workflow: Build, Scan & Push

This GitHub Actions workflow automates the CI/CD pipeline for your Spring Boot application packaged inside Docker. It ensures your code is built, tested, scanned for vulnerabilities, and deployed as a Docker image to Docker Hub.
Workflow Trigger. Runs on every push to the main branch.

##  Workflow Jobs & Steps
###  Checkout Repository
```
- name: Checkout repository
  uses: actions/checkout@v2
  ```
Pulls your project’s source code from GitHub into the workflow runner.

### Set up JDK 17
```
- name: Set up JDK 17
  uses: actions/setup-java@v2
  with:
    distribution: 'adopt'
    java-version: '17'
```

Installs Java 17 (AdoptOpenJDK distribution).

Required for building your Spring Boot app with Maven.
### Build with Maven
```
- name: Build with Maven
  run: mvn clean package
  working-directory: javapack
```

Compiles and packages the Spring Boot application into a JAR.

Uses the javapack folder for the Maven project.
### Login to Docker Hub
```
- name: Login to Docker Hub
  uses: docker/login-action@v2
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}
```

Authenticates with Docker Hub using GitHub secrets for security.

Secrets are stored in GitHub repository → Settings → Secrets.
### Build Docker Image
```
- name: Build Docker image
  run: docker build -t ${{ secrets.DOCKER_USERNAME }}/springboot-app:${{ github.run_number }} -f javapack/Dockerfile javapack
```

Builds a Docker image from the app’s Dockerfile.

Tags the image as:

<DOCKER_USERNAME>/springboot-app:<GitHub_Run_Number>


(Run number ensures unique versioning for every build).
### Install Trivy
```
- name: Install Trivy
  run: |
    sudo apt-get update
    sudo apt-get install -y wget apt-transport-https gnupg lsb-release
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
    echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
    sudo apt-get install -y trivy
```

Installs Trivy, an open-source vulnerability scanner.
### Scan Docker Image for Vulnerabilities
```
- name: Scan Docker image for vulnerabilities
  run: |
    trivy image --severity CRITICAL ${{ secrets.DOCKER_USERNAME }}/springboot-app:${{ github.run_number }}
```

Scans the built Docker image for critical security vulnerabilities.

Prevents pushing unsafe images to Docker Hub.
### Push Docker Image to Docker Hub
```
- name: Push Docker image
  run: |
    docker push ${{ secrets.DOCKER_USERNAME }}/springboot-app:${{ github.run_number }}
```

Pushes the Docker image to Docker Hub registry.

Makes the image available for deployments (Kubernetes, Docker Swarm, etc.).

### Logout from Docker Hub
```
- name: Logout from Docker Hub
  run: docker logout
```


Clears Docker Hub login credentials for security.

✅ Benefits of this Workflow

Automated Build: Every push triggers a fresh build.

Security First: Trivy scan ensures no critical vulnerabilities pass through.

Versioning: Each build gets a unique tag using GitHub run number.

Continuous Deployment Ready: The pushed Docker image can be deployed directly to Kubernetes or cloud environments.

👉 This workflow makes your project CI/CD ready with DevSecOps best practices (security integrated into CI/CD).
