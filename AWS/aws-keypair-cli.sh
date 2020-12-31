# Create key pair on AWS
myKeyPair="foo"
aws ec2 create-key-pair --key-name $myKeyPair --query "KeyMaterial" --output text > $myKeyPair.pem

# Set permissions
ls -lF $myKeyPair.pem
chmod 400 $myKeyPair.pem

# Fingerprint is
aws ec2 describe-key-pairs --key-names $myKeyPair --query "KeyPairs[0].KeyFingerprint" --output text

# Fingerprint shown by AWS is the sha1 hash of the key process as SSH2 key 
# (not as openSSH key, so 'ssh-keygen -l -E sha1' will show a different fingerprint)
openssl pkcs8 -in $myKeyPair.pem -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c

# Attention! Key pairs generated locally and uploaded to AWS are different.
# Keys uploaded to AWS are showing a md5 hash as fingerprint, e.g.
openssl rsa -in ~/.ssh/id_rsa -pubout -outform DER | openssl md5 -c
aws ec2 describe-key-pairs --key-names "tj@foo.local" --query "KeyPairs[0].KeyFingerprint" --output text

# Inside .pem file resides both public and private key
cat $myKeyPair.pem

# Extract public key (for reimport into another zone)
ssh-keygen -y -f $myKeyPair.pem

