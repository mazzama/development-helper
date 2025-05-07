# GCP Notes

## SSH Tunneling through IAP
`gcloud compute ssh dev-azzam-vm --project alert-basis-457604-v7 --zone asia-southeast2-a --tunnel-through-iap --ssh-flag="-N" --ssh-flag="-L 6379:localhost:6379"`