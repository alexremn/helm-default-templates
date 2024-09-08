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
  - secretKey: {{ if eq (typeOf .) "string" }}{{ . }}{{ else }}{{ .name }}{{ end }}
    remoteRef:
      key: {{ $remoteKey | quote }}
      property: {{ if eq (typeOf .) "string" }}{{ . }}{{ else }}{{ .property }}{{ end }}
{{- end }}
{{- end }}
---
{{- end }}
{{- end }}
