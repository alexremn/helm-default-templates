{{- define "chart.secret.external.multi" -}}
{{- range $secretName, $secretConfig := .Values.extSecrets }}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ $secretName }}
  labels: {{ include "chart.labels" $ | nindent 4 }}
  annotations:
    force-sync: {{ now | quote }}
spec:
  refreshInterval: '0'
  secretStoreRef:
    kind: ClusterSecretStore
    name: {{ $secretConfig.secretStore }}
  target:
    creationPolicy: Owner
    name: {{ $secretName }}
  data:
{{- range $secretConfig.secrets }}
{{- $remoteKey := .name }}
{{- range .keys }}
  - secretKey: {{ . }}
    remoteRef:
      key: {{ $remoteKey }}
      property: {{ . }}
{{- end }}
{{- end }}
---
{{- end }}
{{- end }}
