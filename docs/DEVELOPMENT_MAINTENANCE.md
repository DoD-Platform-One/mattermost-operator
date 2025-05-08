# How to Upgrade this Package

Upgrading the mattermost operator instance can be a little tricky since there are a number of changes that are unique to the mattermost operator instance deployed by Big Bang.

Since the mattermost operator chart is built and maintained by Big Bang syncing with upstream is not as straight forward as a `kpt pkg update`.

1. Run `kpt pkg update docs/upstream@{NEW OPERATOR TAG} --strategy force-delete-replace`. Notice that this updates the folder `docs/upstream`.

2. Incrementally copy the CRD sections from `docs/upstream/mattermost-operator.yaml` into their respective files in `chart/mattermost-operator-crds/templates` (it can be helpful to search for `---` to find the sections). At this step the following file names to match the CRD names are: `clusterinstallations.mattermost.com`, `mattermostrestoredbs.mattermost.com`, and `mattermosts.installation.mattermost.com`.

3. Modify each CRD file to remove `creationTimestamp: null` and add labels. Labels to add:

```yaml
  labels:
    app.kubernetes.io/managed-by: '{{ .Release.Service }}'
    app.kubernetes.io/instance: '{{ .Release.Name }}'
    app.kubernetes.io/version: '{{ .Chart.AppVersion }}'
    helm.sh/chart: '{{ .Chart.Name }}-{{ .Chart.Version }}'
```

4. Update `chart/mattermost-operator-crds/Chart.yaml` `version` and `appVersion` to the new operator version.

5. Update the versions for `chart/Chart.yaml` to the new operator version (`version`, `appVersion`, dependency `version`, and annotations).

6. Run `helm dependency update ./chart` and validate that the new CRD chart tgz is under `chart/charts`.

7. Incrementally copy out the remaining sections from `docs/upstream/mattermost-operator.yaml` into their respective files in `chart/templates`. At this step the following file names to match the object types are: `clusterrole`, `clusterrolebinding`, `service`, `serviceaccount`, and `deployment`.

8. Modify each to add labels and remove `creationTimestamp: null`. Any spot where `namespace:` if referenced should become `{{ .Release.Namespace }}` instead of hardcoded `mattermost-operator`. As before, the labels to add:

```yaml
  labels:
    app.kubernetes.io/managed-by: '{{ .Release.Service }}'
    app.kubernetes.io/instance: '{{ .Release.Name }}'
    app.kubernetes.io/version: '{{ .Chart.AppVersion }}'
    helm.sh/chart: '{{ .Chart.Name }}-{{ .Chart.Version }}'
```

9. For the deployment file: make sure that you maintain the existing values mapping for `replicas`, `image`, `resources`, `imagePullSecrets`, `securityContext`, `nodeSelector`, `affinity`, and `tolerations`. These are all BigBang additions that we need to keep.

10. Modify `chart/values.yaml` to use the latest image under `image.tag`.

11. Add a changelog entry for the Chart version.

12. Update top-level ./README.md using script from [gluon library](https://repo1.dso.mil/platform-one/big-bang/apps/library-charts/gluon/-/blob/master/docs/bb-package-readme.md).

13. Open an MR on Repo1 and validate that all changes look as expected in the diffs and CI passes. Make any necessary changes if something looks off or CI fails.

# How to test the upgrade

## Cluster setup

Always make sure your local bigbang repo is current before deploying.

1. Export your Ironbank/Harbor credentials (this can be done in your ~/.bashrc or ~/.zshrc file if desired). These specific variables are expected by the k3d-dev.sh script when deploying metallb, and are referenced in other commands for consistency:

```
export REGISTRY_USERNAME='<your_username>'
export REGISTRY_PASSWORD='<your_password>'
```
2. Export the path to your local bigbang repo (without a trailing /):
Note that wrapping your file path in quotes when exporting will break expansion of ~.
```
export BIGBANG_REPO_DIR=<absolute_path_to_local_bigbang_repo>
```
e.g.
```
export BIGBANG_REPO_DIR=~/repos/bigbang
```
3. Run the k3d_dev.sh script to deploy a dev cluster (-a flag required if deploying a local Keycloak):
```
"${BIGBANG_REPO_DIR}/docs/assets/scripts/developer/k3d-dev.sh"
```
4. Export your kubeconfig:
```
export KUBECONFIG=~/.kube/<your_kubeconfig_file>
```
e.g.
```
export KUBECONFIG=~/.kube/Sam.Sarnowski-dev-config
```
5. Deploy flux to your cluster:
```
"${BIGBANG_REPO_DIR}/scripts/install_flux.sh -u ${REGISTRY_USERNAME} -p ${REGISTRY_PASSWORD}"
```

## Deploy Bigbang Mattermost

```
  helm upgrade -i bigbang ${BIGBANG_REPO_DIR}/chart/ -n bigbang --create-namespace \
  --set registryCredentials.username=${REGISTRY_USERNAME} --set registryCredentials.password=${REGISTRY_PASSWORD} \
  -f https://repo1.dso.mil/big-bang/bigbang/-/raw/master/tests/test-values.yaml \
  -f https://repo1.dso.mil/big-bang/bigbang/-/raw/master/chart/ingress-certs.yaml \
  -f docs/dev-overrides/minimal.yaml \
  -f docs/dev-overrides/docs/dev-overrides/mattermost-testing.yaml
  ```
This will deploy the following apps for testing:

Mattermost, Mattermost Operator
Grafana, Prometheus, ElasticSearch (if enabled)

- Make sure Mattermost Operator pods/services is up and running with healthy status. 
- Scaled Mattermost via Operator
- Accessed web UI

## Big Bang Integration Testing

As part of your MR that modifies bigbang packages, you should modify the bigbang [bigbang/tests/test-values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/tests/test-values.yaml?ref_type=heads) against your branch for the CI/CD MR testing by enabling your packages.

To do this, at a minimum, you will need to follow the instructions at [bigbang/docs/developer/test-package-against-bb.md](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/developer/test-package-against-bb.md?ref_type=heads) with changes for Velero enabled (the below is a reference, actual changes could be more depending on what changes where made to Velero in the pakcage MR).
```yaml
addons:
  mattermost:
    enabled: true
    sso:
      enabled: true
    values:
      enterprise:
        enabled: true
      monitoring:
        enabled: true

  mattermostOperator:
    enabled: true
    git:
      tag: null
      # branch: 33-implement-istio-authorization-policies
      branch: "renovate/ironbank"
    values:
      istio:
        hardened:
          enabled: true
          # enabled: false

  minio:
    enabled: true
    # git:
    #   tag: null
    #   branch: master
```

# Chart Additions

### automountServiceAccountToken
The mutating Kyverno policy named `update-automountserviceaccounttokens` is leveraged to harden all ServiceAccounts in this package with `automountServiceAccountToken: false`. This policy is configured by namespace in the Big Bang umbrella chart repository at [chart/templates/kyverno-policies/values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/chart/templates/kyverno-policies/values.yaml?ref_type=heads). 

This policy revokes access to the K8s API for Pods utilizing said ServiceAccounts. If a Pod truly requires access to the K8s API (for app functionality), the Pod is added to the `pods:` array of the same mutating policy. This grants the Pod access to the API, and creates a Kyverno PolicyException to prevent an alert.

# Files that need integration testing

If you modify any of these things, you should perform an integration test with your branch against the rest of bigbang. Some of these files have automatic tests already defined, but those automatic tests may not model corner cases found in full integration scenarios.

* `./chart/templates/bigbang/*`
* `./chart/templates/clusterrole.yaml`
* `./chart/templates/clusterrolebinding.yaml`
* `./chart/values.yaml` if it involves any of:
  * monitoring changes
  * network policy changes
  * kyverno policy changes
  * istio hardening rule changes
  * service definition changes
  * TLS settings

Follow [the standard process](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/developer/test-package-against-bb.md?ref_type=heads) for performing an integration test against bigbang.
