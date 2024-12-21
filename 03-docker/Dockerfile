# Use Amazon Linux 2023 as the base image
FROM amazonlinux:2023

# Update the package manager and install Python 3 and pip

RUN yum update -y && \
    yum install -y python3-pip && \
    yum clean all && \
    mkdir /flask && \
    chmod 777 /flask

COPY app.py /flask/
COPY requirements.txt /flask/
COPY start_flask_app.sh /flask/
COPY utils.py /flask/

RUN chmod +x /flask/start_flask_app.sh &&  \
    pip3 install -r /flask/requirements.txt

# Set a default command
ENTRYPOINT [ "/flask/start_flask_app.sh" ]