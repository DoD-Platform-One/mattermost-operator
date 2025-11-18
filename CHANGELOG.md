# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---
## [1.25.3-bb.0] (2025-11-12)
### Changed
- Updated registry1.dso.mil/ironbank/opensource/mattermost/mattermost-operator (source) v1.25.2 -> v1.25.3

## [1.25.2-bb.1] (2025-11-03)
### Changed
- Updated the allow-egress-api network policy template to allow setting vpcCidr

## [1.25.2-bb.0] (2025-10-03)
### Changed
- Updated registry1.dso.mil/ironbank/opensource/mattermost/mattermost-operator (source) v1.25.1 -> v1.25.2

## [1.25.1-bb.1] (2025-09-17)
### Changed
- Removed mattermost-operator-crds-1.24.0

## [1.25.1-bb.0] (2025-09-10)
### Changed

- registry1.dso.mil/ironbank/opensource/mattermost/mattermost-operator (source) v1.25.0 -> v1.25.1
- registry1.dso.mil/ironbank/opensource/mattermost/mattermost-operator (source) 1.25.0 -> 1.25.1

## [1.25.0-bb.0] (2025-08-06)
### Changed

- registry1.dso.mil/ironbank/opensource/mattermost/mattermost-operator (source) v1.24.0 -> v1.25.0
- registry1.dso.mil/ironbank/opensource/mattermost/mattermost-operator (source) 1.24.0 -> 1.25.0

## [1.24.0-bb.0] (2025-07-25)

### Changed

- registry1.dso.mil/ironbank/opensource/mattermost/mattermost-operator (source) v1.23.0 -> v1.24.0
- registry1.dso.mil/ironbank/opensource/mattermost/mattermost-operator (source) 1.23.0 -> 1.24.0

## [1.23.0-bb.0] (2025-05-02)

### Changed

- ironbank/opensource/mattermost/mattermost-operator updated from 1.22.1 to 1.23.0

## [1.22.1-bb.2] - 2024-03-28

### Changed

- Updated BB networkpolicy matchLabels

## [1.22.1-bb.1] - 2024-12-03

### Changed

- Added mattermost-operator.podLabels and imported into the deployment

## [1.22.1-bb.0] - 2024-10-04

### Changed

- ironbank/opensource/mattermost/mattermost-operator updated from 1.22.0 to 1.22.1
- Added the maintenance track annotation and badge

## [1.22.0-bb.5] - 2024-08-15

### Added

- Added podLabels value and usage on operator pod

## [1.22.0-bb.4] - 2024-08-14

### Changed

- Fixed minor issues in documentation

## [1.22.0-bb.3] - 2024-08-12

### Changed

- Updated ironbank image for 1.22.0

## [1.22.0-bb.2] - 2024-07-29

### Changed

- Updated ironbank image to latest v1.22.0
- Updated CRD references to v1.22.0; the KPTfile and actual content were already pulled from v1.22.0 upstream but the chart references lagged at 1.20.1.

## [1.22.0-bb.1] - 2024-07-23

### Changed

- Added integration testing instructions for External Secrets Operator

## [1.22.0-bb.0] - 2024-07-13

### Changed

- ironbank/opensource/mattermost/mattermost-operator updated from 1.21.0 to 1.22.0

## [1.21.0-bb.2] - 2024-06-25

### Changed

- Removed shared istio auth policies

## [1.21.0-bb.1] - 2024-04-15

### Changed

- Added Istio Sidecar to restrict egress traffic to REGISTRY_ONLY
- Added Istio ServiceEntry to explicitly allow egress

## [1.21.0-bb.0] - 2024-03-26

### Changed

- ironbank/opensource/mattermost/mattermost-operator updated from 1.20.1 to 1.21.0

## [1.20.1-bb.2] - 2021-03-05

### Changed

- Added Openshift updates for deploying mattermost-operator into Openshift cluster

## [1.20.1-bb.1] - 2021-01-23

### Changed

- Added allow-intranet authorization policy
- Added allow-nothing authorization policy
- Added monitoring authorization policy
- Added custom authorization policy template
- Enabled Istio hardnening in test
- Moved the peer authentications

## [1.20.1-bb.0] - 2023-05-9

### Changed

- ironbank/opensource/mattermost/mattermost-operator updated from 1.20.0 to 1.20.1

## [1.20.0-bb.0] - 2023-03-14

### Changed

- ironbank/opensource/mattermost/mattermost-operator updated from 1.19.0 to 1.20.0

## [1.19.0-bb.0] - 2022-12-06

### Changed

- ironbank/opensource/mattermost/mattermost-operator updated from 1.18.1 to 1.19.0

## [1.18.1-bb.1] - 2022-09-08

### Added

- Added default securitycontext to container (drop capabilities, non-privileged, read only fs)
- Added post install package to validate MM successful install

## [1.18.1-bb.0] - 2022-06-23

### Changed

- Updated to latest 1.18.1 image/manifests

## [1.18.0-bb.1] - 2022-06-14

### Changed

- Adding securityContext section to deployment template and chart values.

## [1.18.0-bb.0] - 2022-04-20

### Changed

- Updated to latest IB image 1.18.0

## [1.17.0-bb.3] - 2022-04-12

### Added

- Default Istio `PeerAuthentication` for mTLS

## [1.17.0-bb.2] - 2022-01-31

### Updated

- Update Chart.yaml to follow new standardization for release automation
- Added renovate check to update new standardization

## [1.17.0-bb.1] - 2022-01-12

### Added

- Ability to specify pod annotations in value file.

## [1.17.0-bb.0] - 2022-01-03

### Changed

- Updated to latest IB image 1.17

## [1.16.0-bb.0] - 2021-11-01

### Changed

- Updated to latest IB image 1.16

### Added

- Documentation on how to perform a package update with kpt/manual changes

## [1.15.0-bb.0] - 2021-09-21

### Changed

- Updated to latest IB image 1.15

### Added

- Added support for sidecars via networkPolicies

## [1.14.0-bb.4] - 2021-08-30

### Added

- Added support for tolerations

## [1.14.0-bb.3] - 2021-08-19

### Added

- Added resource requests and limits

## [1.14.0-bb.2] - 2021-06-21

### Added

- Added network policies with a default deny and egress allowed to the API

## [1.14.0-bb.1] - 2021-06-03

### Changed

- Remove network policies

## [1.14.0-bb.0] - 2021-06-01

### Changed

- Updated to latest v1.14.0 operator from IB

## [1.13.0-bb.3] - 2021-05-25

### Added

- Basic network policies to deny all ingress, allow egress only within cluster

## [1.13.0-bb.2] - 2021-04-05

### Added

- Modified pod affinity spec and values, documentation

## [1.13.0-bb.1] - 2021-03-30

### Added

- Added pod affinity and anti-affinity, documentation

## [1.13.0-bb.0] - 2021-03-15

### Changed

- Bumped the operator image to 1.13.0 from Ironbank

## [1.12.0-bb.0] - 2021-02-12

### Added

- Initial operator from upstream v1.12.0 using Ironbank images
