from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from jwcrypto import jwk

# Read the private key from private.pem file
with open("private.pem", "rb") as f:
    private_key_pem = f.read()

# Deserialize the private key
private_key = serialization.load_pem_private_key(
    private_key_pem,
    password=None,
)

# Convert the private key to a JWK object
private_jwk = jwk.JWK.from_pyca(private_key)

# Export the JWK object to a JSON string
private_jwk_json = private_jwk.export_private()

# Save the JSON string to a file named jwt.json
with open("perms-jwk.json", "w") as f:
    f.write(private_jwk_json)

# Print a message indicating success
print("JWK has been saved to perms-jwk.json")
