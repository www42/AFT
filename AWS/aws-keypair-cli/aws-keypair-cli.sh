# Create key pair on AWS
myKey="foo2"
aws ec2 create-key-pair --key-name $myKey --query "KeyMaterial" --output text > $myKey.pem

# Set permissions
ls -lF $myKey.pem
chmod 400 $myKey.pem

# Fingerprint is
aws ec2 describe-key-pairs --key-names $myKey --query "KeyPairs[0].KeyFingerprint" --output text

# Fingerprint shown by AWS is the sha1 hash of the key process as SSH2 key 
# (not as openSSH key, so 'ssh-keygen -l -E sha1' will show a different fingerprint)
openssl pkcs8 -in $myKey.pem -inform PEM -outform DER -topk8 -nocrypt | openssl sha1 -c

# Attention! Key pairs generated locally and uploaded to AWS are different.
# Keys uploaded to AWS are showing a md5 hash as fingerprint, e.g.
openssl rsa -in ~/.ssh/id_rsa -pubout -outform DER | openssl md5 -c
aws ec2 describe-key-pairs --key-names "tj@foo.local" --query "KeyPairs[0].KeyFingerprint" --output text

# Inside .pem file resides both public and private key
cat $myKey.pem

# Extract public key (for reimport into another zone)
ssh-keygen -y -f $myKey.pem

# Clean up
aws ec2 delete-key-pair --key-name $myKey
rm -f $myKey.pem