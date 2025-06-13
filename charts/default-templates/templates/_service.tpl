{{- define "chart.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ template "chart.fullname" . }}
  labels: {{ include "chart.labels" . | nindent 4 }}
  {{- if .Values.service.annotations }}
  annotations: {{ toYaml .Values.service.annotations | nindent 4 }}
  {{- end }}
spec:
  type: {{ .Values.service.type | default "ClusterIP" }}
  {{- if eq "ExternalName" ( default "ClusterIP" .Values.service.type ) }}
  externalName: {{ tpl .Values.service.externalName . }}
  {{- else }}
  ports:
  {{- range .Values.service.ports }}
    - port: {{ default 8080 .port }}
      targetPort: {{ default .port .targetPort }}
      protocol: {{ default "TCP" .protocol }}
      name: {{ .name }}
  {{- end }}
  selector: {{ include "chart.matchLabels" . | nindent 4 }}
  {{- end }}
{{- end }}
