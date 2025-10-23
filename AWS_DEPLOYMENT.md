# AWS Deployment Guide

This guide will help you deploy the Todo Backend API to AWS Elastic Beanstalk.

## Prerequisites

1. AWS Account
2. AWS CLI installed and configured
3. EB CLI installed
4. MongoDB Atlas account (recommended for production)

## Step 1: Install AWS CLI

```bash
# On macOS
brew install awscli

# On Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# On Windows
# Download and run the AWS CLI MSI installer from AWS website
```

## Step 2: Configure AWS CLI

```bash
aws configure
```

Enter your:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., us-east-1)
- Default output format (json)

## Step 3: Install EB CLI

```bash
pip install awsebcli --upgrade --user
```

## Step 4: Set Up MongoDB Atlas

1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a new cluster (free tier available)
3. Create a database user
4. Whitelist all IPs (0.0.0.0/0) or specific AWS regions
5. Get your connection string:
   ```
   mongodb+srv://username:password@cluster.mongodb.net/todo-app?retryWrites=true&w=majority
   ```

## Step 5: Initialize Elastic Beanstalk

In your project directory:

```bash
eb init
```

Configuration:
1. Select region (e.g., us-east-1)
2. Select "Create new Application" or use existing
3. Choose application name: `todo-backend-api`
4. Select platform: `Node.js`
5. Select platform version: `Node.js 18 running on 64bit Amazon Linux 2`
6. Setup SSH: Yes (recommended) or No

## Step 6: Create Environment

```bash
eb create todo-backend-env
```

This will:
- Create a new environment
- Provision AWS resources (EC2, Load Balancer, etc.)
- Deploy your application

## Step 7: Set Environment Variables

```bash
eb setenv \
  NODE_ENV=production \
  MONGODB_URI="your_mongodb_atlas_connection_string" \
  JWT_SECRET="your_strong_random_secret_key" \
  JWT_EXPIRE=7d \
  GOOGLE_CLIENT_ID="your_google_client_id" \
  GOOGLE_CLIENT_SECRET="your_google_client_secret" \
  GOOGLE_CALLBACK_URL="https://your-eb-url.elasticbeanstalk.com/api/auth/google/callback" \
  FRONTEND_URL="https://your-frontend-url.com"
```

**Important**: Replace the values with your actual credentials.

## Step 8: Deploy Application

```bash
eb deploy
```

This will:
- Package your application
- Upload to S3
- Deploy to your environment

## Step 9: Open Your Application

```bash
eb open
```

This will open your application in a browser.

## Step 10: Monitor Your Application

```bash
# Check status
eb status

# View logs
eb logs

# SSH into instance
eb ssh
```

## Environment Configuration

The `.ebextensions` directory contains:

### nodecommand.config
- Sets Node.js version to 18.x
- Configures environment variables
- Sets instance type (t2.micro for free tier)

### nginx.config
- Configures Nginx (reverse proxy)
- Sets client max body size to 10MB

## Scaling

### Vertical Scaling (Instance Size)

Edit `.ebextensions/nodecommand.config`:

```yaml
aws:autoscaling:launchconfiguration:
  InstanceType: t2.small  # or t2.medium, t2.large
```

Then deploy:
```bash
eb deploy
```

### Horizontal Scaling (Auto Scaling)

```bash
# Via console
eb scale 2

# Or via configuration
eb config
```

Add auto-scaling configuration:
```yaml
aws:autoscaling:asg:
  MinSize: 1
  MaxSize: 4
aws:autoscaling:trigger:
  MeasureName: CPUUtilization
  Statistic: Average
  Unit: Percent
  UpperThreshold: 80
  LowerThreshold: 20
```

## Security Best Practices

1. **Never commit secrets**: Use environment variables
2. **Use IAM roles**: Instead of access keys when possible
3. **Enable HTTPS**: Use AWS Certificate Manager
4. **Restrict Security Groups**: Only open necessary ports
5. **Regular updates**: Keep dependencies updated

## Enable HTTPS

1. Request a certificate in AWS Certificate Manager
2. Configure load balancer in EB console:
   - Go to Configuration → Load Balancer
   - Add HTTPS listener
   - Select your certificate

## Custom Domain

1. Get your EB environment URL:
   ```bash
   eb status
   ```

2. In Route 53 or your DNS provider:
   - Create CNAME record pointing to EB URL
   - Or use A record with Alias to EB environment

3. Update environment variables:
   ```bash
   eb setenv GOOGLE_CALLBACK_URL="https://api.yourdomain.com/api/auth/google/callback"
   ```

## Monitoring and Logging

### CloudWatch Logs

Enable enhanced health reporting:
```bash
eb config
```

Add:
```yaml
aws:elasticbeanstalk:cloudwatch:logs:
  StreamLogs: true
  DeleteOnTerminate: false
  RetentionInDays: 7
```

### Application Monitoring

Consider adding:
- AWS CloudWatch for metrics
- Third-party services (Datadog, New Relic)
- Error tracking (Sentry)

## Cost Optimization

1. **Use t2.micro**: Free tier eligible
2. **Single instance**: For development
3. **Reserved instances**: For production (up to 75% savings)
4. **Auto-scaling**: Scale down during off-hours
5. **Monitor usage**: Use AWS Cost Explorer

## Troubleshooting

### Deployment Failed

```bash
# View detailed logs
eb logs --all

# Check environment health
eb health
```

### Application Not Starting

1. Check environment variables are set
2. Verify MongoDB connection string
3. Check logs for errors

### 502 Bad Gateway

- Application not listening on correct port
- Check PORT environment variable is set
- Verify application starts successfully

### Database Connection Issues

- Verify MongoDB Atlas IP whitelist
- Check connection string format
- Ensure database user has correct permissions

## Continuous Deployment

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to EB

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Generate deployment package
        run: zip -r deploy.zip . -x '*.git*'
      
      - name: Deploy to EB
        uses: einaregilsson/beanstalk-deploy@v20
        with:
          aws_access_key: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws_secret_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          application_name: todo-backend-api
          environment_name: todo-backend-env
          version_label: ${{ github.sha }}
          region: us-east-1
          deployment_package: deploy.zip
```

## Cleanup

To avoid charges, terminate your environment when not needed:

```bash
# Terminate environment
eb terminate todo-backend-env

# Delete application (removes all environments)
eb terminate --all
```

## Additional Resources

- [AWS Elastic Beanstalk Documentation](https://docs.aws.amazon.com/elasticbeanstalk/)
- [EB CLI Documentation](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html)
- [MongoDB Atlas Documentation](https://docs.atlas.mongodb.com/)
- [Node.js on AWS](https://aws.amazon.com/sdk-for-node-js/)

## Support

For deployment issues:
1. Check AWS service health status
2. Review CloudWatch logs
3. Check EB environment health dashboard
4. Consult AWS documentation
5. Contact AWS Support (if you have a support plan)
