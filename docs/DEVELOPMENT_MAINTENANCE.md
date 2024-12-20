# How to Sync with Upstream

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
