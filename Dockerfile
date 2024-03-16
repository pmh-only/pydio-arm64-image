FROM alpine as builder

RUN apk add --no-cache wget

COPY ./start.sh /bin/start.sh

ARG VERSION

RUN wget https://download.pydio.com/pub/cells/release/${VERSION}/linux-arm64/cells -O /bin/cells

RUN chmod a+rwx /bin/start.sh /bin/cells

FROM alpine as runner

RUN apk add --no-cache gcompat jq

EXPOSE 8080

ENV CADDYPATH /var/cells/certs 
ENV CELLS_WORKING_DIR /var/cells

WORKDIR $CELLS_WORKING_DIR
VOLUME ["$CELLS_WORKING_DIR"]

COPY --from=builder /bin/cells /bin/cells
COPY --from=builder /bin/start.sh /bin/start.sh

ENTRYPOINT ["/bin/start.sh"]
CMD ["/bin/cells", "start"]
