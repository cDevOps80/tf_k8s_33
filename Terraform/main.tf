module "event-bridge" {
  source   = "./modules/event-bridge"
  arn      = "arn:aws:lambda:us-east-1:041445559784:function:sample1"
}