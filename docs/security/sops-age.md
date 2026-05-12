# Guía: SOPS + age para secretos

## ¿Qué resuelve?
Permite guardar secretos cifrados en Git sin exponer valores reales en manifiestos.

## 1) Instalar herramientas
- `sops`
- `age`

## 2) Generar llave age (local)
```bash
age-keygen -o ~/.config/sops/age/keys.txt
```
Obtén la llave pública:
```bash
grep '^# public key:' ~/.config/sops/age/keys.txt
```

## 3) Configurar reglas SOPS
1. Copiar `security/sops/.sops.yaml.example` a `.sops.yaml` en la raíz del repo.
2. Reemplazar `age1xxxx...` por tu llave pública.

## 4) Crear y cifrar secreto
Ejemplo:
```bash
cat > security/sops/secrets/homepage.env.yaml <<'YAML'
apiVersion: v1
kind: Secret
metadata:
  name: homepage-env
  namespace: homepage
type: Opaque
stringData:
  HOMEPAGE_VAR: "valor-super-secreto"
YAML

sops --encrypt --in-place security/sops/secrets/homepage.env.yaml
mv security/sops/secrets/homepage.env.yaml security/sops/secrets/homepage.env.enc.yaml
```

## 5) Despliegue
- Con Flux: configurar decrypt con age key en el cluster.
- Sin Flux: descifrar temporalmente en entorno seguro y aplicar con `kubectl`.

## Buenas prácticas
- Rotar llaves periódicamente.
- Un set de secretos por app/entorno.
- Nunca pegar secretos en PRs o issues.
