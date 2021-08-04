{{/*
Expand the name of the chart.
*/}}
{{- define "mongodb-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mongodb-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mongodb-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mongodb-chart.labels" -}}
helm.sh/chart: {{ include "mongodb-chart.chart" . }}
{{ include "mongodb-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mongodb-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mongodb-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mongodb-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mongodb-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Environment Variables
*/}}
{{- define "mongodb-chart.list-env-variables"}}
{{- range .Values.env.mongo.secret }}
- name: {{ .name | quote }}
  value: {{ .value | quote }}
{{- end}}
{{- end }}

{{/*
Volume secrets
*/}}
{{- define "mongodb-chart.list-volume-items"}}
{{- range .Values.volume.items }}
- key: {{ .key | quote }}
  path: {{ .path | quote }}
  mode: {{ .mode }}
{{- end}}
{{- end }}