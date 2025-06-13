{{- define "chart.deployment" -}}
apiVersion: {{ include "common.capabilities.deployment.apiVersion" . }}
kind: Deployment
metadata:
  name: {{ template "chart.fullname" . }}
  labels: {{ include "chart.labels" . | nindent 4 }}
spec:
  {{- if .Values.deployment }}
  {{- with .Values.deployment }}
  revisionHistoryLimit: {{ default 1 .revisions }}
  strategy:
    type: {{ .strategy | default "RollingUpdate" | toString }}
  {{- end }}
  {{- else }}
  revisionHistoryLimit: 1
  replicas: {{ default 1 .Values.replicas }}
  strategy:
    type: "RollingUpdate"
  {{- end }}
  selector:
    matchLabels: {{- include "chart.matchLabels" . | nindent 6 }}
  template:
    metadata:
      labels: {{- include "chart.labels" . | nindent 8 }}
        {{- if .Values.podLabels }}
        {{- toYaml .Values.podLabels | nindent 8 }}
        {{- end }}
      annotations:
        lastUpdate: {{ now }}
        {{- if .Values.podAnnotations }}
        {{- toYaml .Values.podAnnotations | nindent 8 }}
        {{- end }}
    spec:
      {{- if .Values.global.imagePullSecret }}
      imagePullSecrets:
        - name: {{ .Values.global.imagePullSecret | quote }}
      {{- else if .Values.image.pullSecret }}
      imagePullSecrets:
        - name: {{ .Values.image.pullSecret | quote }}
      {{- end }}
      {{- if .Values.initContainers }}
      initContainers: {{- tpl .Values.initContainers $ | nindent 8 }}
      {{- end }}
      {{- if .Values.serviceAccount }}
      serviceAccountName: {{ tpl .Values.serviceAccount . }}
      {{- end }}
      {{- if .Values.podSecurityContext }}
      securityContext: {{- toYaml .Values.podSecurityContext | nindent 8 }}
      {{- end }}
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ tpl .Values.image.repository . }}/{{ tpl .Values.image.name . }}:{{ tpl .Values.image.tag . }}"
          {{- if .Values.command }}
          command: {{- toYaml .Values.command | nindent 12  }}
          {{- end }}
          {{- if .Values.args }}
          args: {{- toYaml .Values.args | nindent 12  }}
          {{- end }}
          {{- if .Values.containerSecurityContext }}
          securityContext: {{- toYaml .Values.containerSecurityContext | nindent 12 }}
          {{- end }}
          imagePullPolicy: {{ .Values.image.pullPolicy | default "IfNotPresent" | quote }}
          {{- if .Values.service }}
          ports:
          {{- range $port := .Values.service.ports }}
            - containerPort: {{ $port.targetPort | default $port.port }}
              name: {{ $port.name }}
          {{- end }}
          {{- end }}
          {{- if .Values.livenessProbe }}
          livenessProbe: {{- toYaml .Values.livenessProbe | nindent 12 }}
          {{- end }}
          {{- if .Values.readinessProbe }}
          readinessProbe: {{- toYaml .Values.readinessProbe | nindent 12 }}
          {{- end }}
          {{- if .Values.startupProbe }}
          startupProbe: {{- toYaml .Values.startupProbe | nindent 12 }}
          {{- end }}
          {{- if .Values.envVars }}
          env:
          {{- range $key, $value := .Values.envVars }}
              {{- printf "- name: %s\n  value: %s" $key ($value | toString | quote) | nindent 12 }}
          {{- end }}
          {{- end }}
          envFrom:
            {{- if .Values.envFromCM }}
            {{- range .Values.envFromCM }}
            - configMapRef:
                name: {{ . | quote }}
            {{- end }}
            {{- end }}
            {{- if .Values.envFromSecret }}
            {{- range .Values.envFromSecret }}
            - secretRef:
                name: {{ . | quote }}
            {{- end }}
            {{- end }}
          {{- if .Values.volumeMounts }}
          volumeMounts: {{- toYaml .Values.volumeMounts | nindent 12 }}
          {{- end }}
          {{- if .Values.resources }}
          resources: {{- toYaml .Values.resources | nindent 12 }}
          {{- end }}
      {{- if .Values.nodeSelector }}
      nodeSelector: {{- toYaml .Values.nodeSelector | nindent 8 }}
      {{- end }}
      {{- if .Values.affinity }}
      affinity: {{- toYaml .Values.affinity | nindent 8 }}
      {{- end }}
      {{- if .Values.tolerations }}
      tolerations: {{- toYaml .Values.tolerations | nindent 8 }}
      {{- end }}
      {{- if .Values.volumes }}
      volumes: {{- toYaml .Values.volumes | nindent 8 }}
      {{- end }}
{{- end }}
