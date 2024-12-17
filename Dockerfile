FROM python:3.9-alpine3.13

# Metadata
LABEL maintainer="londonappdeveloper.com"

# Cấu hình Python
ENV PYTHONUNBUFFERED=1

# Sao chép các tệp cần thiết
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Thiết lập thư mục làm việc và cổng
WORKDIR /app
EXPOSE 8000

# Biến ARG để kiểm tra môi trường DEV
ARG DEV=false

# Cài đặt các gói cần thiết và thiết lập môi trường
RUN apk add --no-cache gcc musl-dev libffi-dev && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Cập nhật biến PATH để sử dụng môi trường ảo
ENV PATH="/py/bin:$PATH"

# Chạy với người dùng không phải root
USER django-user
