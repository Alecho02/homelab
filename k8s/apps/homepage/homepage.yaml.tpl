apiVersion: v1
kind: ConfigMap
metadata:
  name: homepage-config
  namespace: homepage
data:
  settings.yaml: |
    title: Homelab
    theme: dark
    color: slate
    layout:
      Media y Descargas:
        style: row
        columns: 2
      Red y DNS:
        style: row
        columns: 2
      Observabilidad:
        style: row
        columns: 3
      Cluster:
        style: row
        columns: 3
      Infra:
        style: row
        columns: 2
  bookmarks.yaml: |
    - Infra:
        - GitHub Homelab:
            - href: https://github.com
              description: Repositorios y automatizacion
  widgets.yaml: |
    - resources:
        cpu: true
        memory: true
        disk: /
    - datetime:
        text_size: xl
        format:
          dateStyle: long
          timeStyle: short
  services.yaml: |
    - Media y Descargas:
        - Jellyfin:
            href: "__JELLYFIN_URL__"
            description: Media server
            icon: jellyfin.png
        - qBittorrent:
            href: "__QBITTORRENT_URL__"
            description: Descargas
            icon: qbittorrent.png
    - Red y DNS:
        - Pi-hole:
            href: "__PIHOLE_URL__"
            description: DNS / ad-block
            icon: pi-hole.png
            widget:
              type: pihole
              url: "__PIHOLE_BASE_URL__"
              version: 6
              key: "{{HOMEPAGE_VAR_PIHOLE_KEY}}"
        - Portainer:
            href: "__PORTAINER_URL__"
            description: Gestion de contenedores en NAS
            icon: portainer.png
    - Observabilidad:
        - Grafana:
            href: "http://grafana.__BASE_DOMAIN__"
            description: Dashboards y metricas
            icon: grafana.png
        - Prometheus:
            href: "http://prometheus.__BASE_DOMAIN__"
            description: Consultas y targets
            icon: prometheus.png
        - Alertmanager:
            href: "http://alertmanager.__BASE_DOMAIN__"
            description: Estado y gestion de alertas
            icon: alertmanager.png
    - Cluster:
        - Headlamp:
            href: "http://headlamp.__BASE_DOMAIN__"
            description: Vista de pods, containers y servicios
            icon: kubernetes.png
        - Jenkins:
            href: "http://jenkins.__BASE_DOMAIN__"
            description: CI server y pipelines
            icon: jenkins.png
        - Argo CD:
            href: "http://argocd.__BASE_DOMAIN__"
            description: GitOps y despliegue continuo
            icon: argo-cd.png
        - pgAdmin:
            href: "http://pgadmin.__BASE_DOMAIN__"
            description: Administracion de PostgreSQL
            icon: pgadmin.png
        - Homepage:
            href: "http://home.__BASE_DOMAIN__"
            description: Portal principal del homelab
            icon: homepage.png
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: homepage
  namespace: homepage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: homepage
  template:
    metadata:
      labels:
        app: homepage
    spec:
      containers:
        - name: homepage
          image: ghcr.io/gethomepage/homepage:latest
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 3000
          envFrom:
            - secretRef:
                name: homepage-secrets
          env:
            - name: HOMEPAGE_ALLOWED_HOSTS
              value: "home.__BASE_DOMAIN__"
          volumeMounts:
            - name: config
              mountPath: /app/config/settings.yaml
              subPath: settings.yaml
            - name: config
              mountPath: /app/config/bookmarks.yaml
              subPath: bookmarks.yaml
            - name: config
              mountPath: /app/config/widgets.yaml
              subPath: widgets.yaml
            - name: config
              mountPath: /app/config/services.yaml
              subPath: services.yaml
            - name: logs
              mountPath: /app/config/logs
      volumes:
        - name: config
          configMap:
            name: homepage-config
        - name: logs
          emptyDir: {}
---
apiVersion: v1
kind: Service
metadata:
  name: homepage
  namespace: homepage
spec:
  selector:
    app: homepage
  ports:
    - name: http
      port: 80
      targetPort: 3000
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: homepage
  namespace: homepage
spec:
  ingressClassName: nginx
  rules:
    - host: home.__BASE_DOMAIN__
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: homepage
                port:
                  number: 80
