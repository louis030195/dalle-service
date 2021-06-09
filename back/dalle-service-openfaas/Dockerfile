
FROM openfaas/classic-watchdog:0.18.8 as watchdog

FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-devel

RUN apt-get -y update && apt-get -y install git gcc llvm-9-dev cmake libaio-dev wget

RUN git clone https://github.com/microsoft/DeepSpeed.git /tmp/DeepSpeed
RUN cd /tmp/DeepSpeed && DS_BUILD_SPARSE_ATTN=1 ./install.sh -r
RUN pip install git+https://github.com/lucidrains/DALLE-pytorch.git

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

#RUN addgroup -g 1000 -S app && adduser -u 1000 -S app -G app
#USER 1000

WORKDIR /home/app

COPY requirements.txt   .
RUN pip install -r requirements.txt

RUN wget https://www.dropbox.com/s/l89xnuy11s1qeqf/16L_64HD_16H_756I_128T_cc12m_1E.pt?dl=1 && \
    echo '{"good": "16L_64HD_16H_756I_128T_cc12m_1E.pt?dl=1"}' > model_paths.json

COPY handler.py .
ENV fprocess="python3 handler.py 1234"

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]