{{- define "chart.ingress.multi" }}
apiVersion: {{ include "common.capabilities.ingress.apiVersion" . }}
kind: Ingress
metadata:
  name: {{ template "chart.fullname" . }}
  labels: {{- include "chart.labels" . | nindent 4 }}
  {{- if .Values.ingress.annotations }}
  annotations: {{- toYaml .Values.ingress.annotations | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.ingress.className }}
  ingressClassName: {{ .Values.ingress.className | quote }}
  {{- else }}
  ingressClassName: nginx
  {{- end }}
  {{- if .Values.ingress.tls.enabled | default ("true") }}
  tls:
    - hosts:
      {{- range $domain, $val := .Values.ingress.config }}
      {{- printf "- %s" ($domain | toString | quote) | nindent 8 }}
      {{- end }}
      {{- range $domain := .Values.ingress.extraDomains }}
      {{- printf "- %s" ($domain | toString | quote) | nindent 8 }}
      {{- end }}
      {{- if .Values.ingress.tls.secretName }}
      secretName: {{ .Values.ingress.tls.secretName }}
      {{- else }}
      secretName: {{ tpl .Values.ingress.domain . }}-tls
      {{- end }}
  {{- end }}  
  rules:
  {{- range $domain, $val := .Values.ingress.config }}
    - host: {{ $domain }}
      http:
        paths:
        {{- if .paths }}
        {{- range $path, $var := .paths }}
        - path: {{ if eq $path "root" }}{{ printf "/" }}{{ else }}{{ printf "/%s" $path }}{{ end }}
          pathType: {{ .pathType | default ("ImplementationSpecific") }}
          backend:
            service:
              name: {{ .service | default (include "chart.fullname" $) }}
              port:
              {{- if .portName }}
                name: {{ .portName }}
              {{- else }}
                number: {{ if $.Values.service -}} {{ .port | default ((index $.Values.service.ports 0).port)}} {{- else -}} {{ .port }} {{- end }}
              {{- end }}
        {{- end }}
        {{- else }}
        - path: {{ .path | default ("/") }}
          pathType: {{ .pathType | default ("ImplementationSpecific") }}
          backend:
            service:
              name: {{ .service | default (include "chart.fullname" $) }}
              port:
              {{- if .portName }}
                name: {{ .portName }}
              {{- else }}
                number: {{ .port | default ((index $.Values.service.ports 0).port)}}
              {{- end }}
        {{- end }}
  {{- end }}
{{- end }}
