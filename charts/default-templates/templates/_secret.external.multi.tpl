{{- define "chart.secret.external.multi" -}}
{{- range $secret, $val := .Values.extSecrets }}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ $secret }}
  labels: {{ include "chart.labels" . | nindent 4 }}
   annotations:
    force-sync: {{ now | quote }}
spec:
  refreshInterval: '0'
  secretStoreRef:
    kind: ClusterSecretStore
    name: secrets-manager
  target:
    creationPolicy: Owner
    name: {{ $secret }}
  data:
{{- range $key, $value := $val }}
  - secretKey: {{ $key }}
    remoteRef:
      key: {{ $value }}
      property: {{ $key }}
{{- end }}
---
{{- end }}
{{- end }}
