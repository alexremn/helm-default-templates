{{- define "chart.secret.external.multi" -}}
{{- $secretStore := .Values.extSecrets.secretStore }}
{{- range $secret, $val := .Values.extSecrets.values }}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ $secret }}
  labels: {{ include "chart.labels" $ | nindent 4 }}
  annotations:
    force-sync: {{ now | quote }}
spec:
  refreshInterval: '0'
  secretStoreRef:
    kind: ClusterSecretStore
    name: {{ $secretStore }}
  target:
    creationPolicy: Owner
    name: {{ $secret }}
  data:
{{- range $key, $secrets := $val }}
{{- range $secrets }}
  - secretKey: {{ . }}
    remoteRef:
      key: {{ $key }}
      property: {{ . }}
{{- end }}
{{- end }}
---
{{- end }}
{{- end }}
