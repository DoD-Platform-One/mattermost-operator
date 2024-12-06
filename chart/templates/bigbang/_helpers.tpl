{{/*
*/}}
{{- define "mattermost-operator.selectorLabels" -}}
app.kubernetes.io/managed-by: "{{ .Release.Service }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}

{{- define "mattermost-operator.podLabels" -}}
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/name: "{{ .Chart.Name }}"
app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
{{- end -}}


{{- define "mattermost-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

