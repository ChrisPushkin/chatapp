FROM python:3.8.6-alpine3.12 as build
RUN apk add --no-cache gcc libffi-dev openssl-dev musl-dev
WORKDIR /app
COPY requirements.txt requirements.txt
RUN python3 -m venv venv
ENV PATH=:/app/venv/bin:$PATH
RUN pip3 install --upgrade pip
RUN pip3 install pymysql gunicorn
RUN pip3 install -r requirements.txt
COPY . .
RUN chmod u+x entrypoint.sh 
#RUN apk add --no-cache --virtual .build-deps \
#    gcc libffi-dev openssl-dev musl-dev && \
#    pip3 install --upgrade pip && \
#    pip3 install -r requirements.txt && \
#    pip3 install pymysql && \
#    apk del .build-deps
#RUN pip3 install --upgrade pip && pip3 install -r requirements.txt

FROM python:3.8.6-alpine3.12 as run
RUN adduser -HD -u 1000 chat
ENV PATH=:/app/venv/bin:$PATH
COPY --from=build --chown=chat:chat /app /app
#RUN chown -R chat: /app
WORKDIR /app
USER chat
ENTRYPOINT ["flask", "run", "-h", "0.0.0.0"]
ENV DATABASE_URL='sqlite:///app'
