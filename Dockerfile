FROM alpine as builder

RUN apk add --no-cache wget

ARG VERSION

RUN wget https://download.pydio.com/pub/cells/release/${VERSION}/linux-arm64/cells -O /bin/cells

RUN chmod a+rwx /bin/cells

FROM alpine as runner

RUN apk add --no-cache gcompat jq

WORKDIR /app

VOLUME ["/app"]

EXPOSE 8080

COPY --from=builder /bin/cells /bin/cells

ENTRYPOINT ["/bin/cells"]
CMD ["start"]
