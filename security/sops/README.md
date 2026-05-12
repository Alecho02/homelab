# SOPS + age (base)

Este directorio define la convención para manejar secretos sin exponer datos sensibles en Git.

## Flujo recomendado
1. Generar llave age local (fuera del repo).
2. Definir `.sops.yaml` en raíz del repo (desde `.sops.yaml.example`).
3. Crear secretos en YAML y cifrarlos con `sops`.
4. Subir solo archivos cifrados (`*.enc.yaml`).

## NUNCA subir al repo
- llave privada age (`keys.txt`)
- secretos sin cifrar
- tokens o passwords en texto plano

## Estructura sugerida
- `security/sops/.sops.yaml.example` → plantilla de reglas
- `security/sops/secrets/` → secretos cifrados por app/entorno
