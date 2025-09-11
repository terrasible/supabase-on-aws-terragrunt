#!/usr/bin/env python3
import jwt
import sys
import time

# Get secret from command line argument
secret = sys.argv[1] if len(sys.argv) > 1 else None

# Current timestamp
current_time = int(time.time())

# Generate anon key
anon_payload = {
    'iss': 'supabase',
    'ref': 'supabase-thanos',
    'role': 'anon',
    'iat': current_time,
    'exp': current_time + (365 * 24 * 60 * 60)  # 1 year
}

# Generate service key
service_payload = {
    'iss': 'supabase',
    'ref': 'supabase-thanos',
    'role': 'service_role',
    'iat': current_time,
    'exp': current_time + (365 * 24 * 60 * 60)  # 1 year
}

# Generate JWT tokens
anon_key = jwt.encode(anon_payload, secret, algorithm='HS256')
service_key = jwt.encode(service_payload, secret, algorithm='HS256')

print(f'ANON_KEY: {anon_key}')
print(f'SERVICE_KEY: {service_key}')
