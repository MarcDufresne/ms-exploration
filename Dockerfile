FROM python:3.6

WORKDIR /app

COPY . .

ENV PATH /root/.local/bin:$PATH

RUN make bootstrap &&\
    make install-deploy

CMD ["make", "run-local"]
