from diagrams import Diagram, Cluster, Edge
from diagrams.azure.containers import ContainerRegistries, KubernetesServices
from diagrams.azure.identity import ManagedIdentities
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import GithubActions

graph_attrs = {
    "fontsize": "13",
    "bgcolor": "white",
    "pad": "0.5",
    "splines": "ortho",
}

node_attrs = {
    "fontsize": "11",
}

with Diagram(
    "Azure DevSecOps Pipeline",
    filename="docs/architecture",
    outformat="png",
    show=False,
    direction="LR",
    graph_attr=graph_attrs,
    node_attr=node_attrs,
):
    repo = Github("GitHub Repo")

    with Cluster("GitHub Actions Pipeline"):
        sast = GithubActions("SAST & IaC\nBandit · pip-audit\nCheckov")
        build = GithubActions("Build & Scan\nDocker · Trivy")
        dast = GithubActions("DAST\nOWASP ZAP")
        deploy = GithubActions("Deploy\nkubectl")

    with Cluster("Azure (eastus)"):
        identity = ManagedIdentities("OIDC\nFederated Identity")
        acr = ContainerRegistries("Azure Container\nRegistry (ACR)")
        aks = KubernetesServices("AKS Cluster\nBlue/Green Pods")

    repo >> Edge(label="push") >> sast
    sast >> build
    build >> dast
    dast >> deploy

    repo >> Edge(style="dashed") >> identity
    build >> Edge(label="push image") >> acr
    acr >> Edge(label="AcrPull") >> aks
    deploy >> Edge(label="kubectl apply") >> aks
