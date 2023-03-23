{{- define "chart.storage.pvc" -}}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ .Values.persistence.claimName | quote }}
  labels:
{{ include "chart.labels" . | indent 4 }}
{{ with .Values.persistence.annotations }}
  annotations:
{{- toYaml . | nindent 4 }}
{{ end }}
spec:
  accessModes:
{{- if .Values.persistence.accessModes }}
{{- range $mode := .Values.persistence.accessModes }}
    - {{ $mode }}
{{- end }}
{{- else }}
    - {{ .Values.persistence.accessMode }}
{{- end }}
  resources:
    requests:
      storage: {{ .Values.persistence.size | quote }}
  storageClassName: {{ .Values.persistence.storageClass }}
{{- end }}
