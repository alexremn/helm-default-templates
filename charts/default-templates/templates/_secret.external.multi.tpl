{{- define "chart.secret.external.multi" -}}
{{- range $secretName, $secretConfig := .Values.extSecrets }}
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: {{ $secretName }}
  labels: {{ include "chart.labels" $ | nindent 4 }}
  annotations:
    force-sync: {{ now | quote }}
spec:
  refreshInterval: '10000h'
  secretStoreRef:
    kind: ClusterSecretStore
    name: {{ $secretConfig.secretStore }}
  target:
    creationPolicy: Owner
    name: {{ $secretName }}
{{- if $secretConfig.manual }}
    template:
      mergePolicy: Merge
      engineVersion: v2
      data: {{ toYaml $secretConfig.manual | nindent 8 }}
{{- end }}
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
