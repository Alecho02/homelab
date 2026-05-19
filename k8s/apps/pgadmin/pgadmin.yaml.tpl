apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pgadmin-data
  namespace: pgadmin
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pgadmin
  namespace: pgadmin
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pgadmin
  template:
    metadata:
      labels:
        app: pgadmin
    spec:
      securityContext:
        fsGroup: 5050
      containers:
        - name: pgadmin
          image: dpage/pgadmin4:latest
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 80
          envFrom:
            - secretRef:
                name: pgadmin-secret
          volumeMounts:
            - name: data
              mountPath: /var/lib/pgadmin
      volumes:
        - name: data
          persistentVolumeClaim:
            claimName: pgadmin-data
---
apiVersion: v1
kind: Service
metadata:
  name: pgadmin
  namespace: pgadmin
spec:
  selector:
    app: pgadmin
  ports:
    - name: http
      port: 80
      targetPort: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: pgadmin
  namespace: pgadmin
spec:
  ingressClassName: nginx
  rules:
    - host: pgadmin.__BASE_DOMAIN__
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: pgadmin
                port:
                  number: 80
