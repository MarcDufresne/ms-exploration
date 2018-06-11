FROM python:3.6

WORKDIR /app

COPY . .

RUN make bootstrap &&\
    make install-prod

CMD ["make", "run-local"]
