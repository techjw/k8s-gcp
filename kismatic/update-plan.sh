#!/usr/bin/env bash

source env.cfg

sed -e "s/%deploy_name%/${DEPLOY_NAME}/g;
  s/%gce_user%/${GCE_USER}/g;
  s#%ssh_key%#${SSH_KEY}#g;
  s/%master1_ip%/${MASTER1_IP}/g;
  s/%master1_pubip%/${MASTER1_PUBIP}/g;
  s/%masterlb_ip%/${MASTERLB_IP}/g;
  s/%worker1_ip%/${WORKER1_IP}/g;
  s/%worker1_pubip%/${WORKER1_PUBIP}/g;
  s/%worker2_ip%/${WORKER2_IP}/g;
  s/%worker2_pubip%/${WORKER2_PUBIP}/g;
  s/%ingress1_ip%/${INGRESS1_IP}/g;
  s/%ingress1_pubip%/${INGRESS1_PUBIP}/g" \
  cluster.yaml.tpl > ${DEPLOY_NAME}-cluster.yaml
