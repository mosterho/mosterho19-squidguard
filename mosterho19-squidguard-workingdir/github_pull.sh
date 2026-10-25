# 1. Initialize an empty local repository
git init

# 2. Link it to the GitHub repository
git remote add -f origin https://github.com

# 3. Enable sparse-checkout
git config core.sparseCheckout true

# 4. Specify the folder you want (e.g., "src/components/*")
echo "path/to/folder/*" >> .git/info/sparse-checkout

# 5. Pull the folder from the main branch
git pull origin main
