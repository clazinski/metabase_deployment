FROM metabase/metabase:v0.39.4

COPY plugins/ojdbc10.jar /app/plugins/

RUN chmod -R 777 /app/plugins/

ENV MB_PLUGINS_DIR /app/plugins/

ENTRYPOINT [ "/app/run_metabase.sh" ]