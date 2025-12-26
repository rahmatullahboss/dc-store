import { Resend } from 'resend';
import type { OrderItem, Address } from '@/db/schema';

// Initialize Resend client
const resend = process.env.RESEND_API_KEY 
  ? new Resend(process.env.RESEND_API_KEY) 
  : null;

// Email configuration
const FROM_EMAIL = process.env.RESEND_FROM_EMAIL || 'DC Store <noreply@digitalcare.site>';

interface OrderEmailData {
  orderNumber: string;
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  items: OrderItem[];
  subtotal: number;
  shippingCost: number;
  total: number;
  shippingAddress: Address;
  paymentMethod: string;
}

/**
 * Generate order confirmation email HTML
 */
function generateOrderConfirmationHTML(data: OrderEmailData): string {
  const itemsHTML = data.items.map(item => `
    <tr>
      <td style="padding: 12px; border-bottom: 1px solid #eee;">
        <div style="display: flex; align-items: center;">
          ${item.image ? `<img src="${item.image}" alt="${item.name}" style="width: 60px; height: 60px; object-fit: cover; margin-right: 12px; border-radius: 8px;">` : ''}
          <div>
            <strong>${item.name}</strong><br>
            <span style="color: #666;">Qty: ${item.quantity}</span>
          </div>
        </div>
      </td>
      <td style="padding: 12px; border-bottom: 1px solid #eee; text-align: right;">
        ৳${(item.price * item.quantity).toLocaleString()}
      </td>
    </tr>
  `).join('');

  return `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Order Confirmation - ${data.orderNumber}</title>
    </head>
    <body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <!-- Header -->
        <div style="background: linear-gradient(135deg, #f59e0b, #ec4899); border-radius: 16px 16px 0 0; padding: 30px; text-align: center;">
          <h1 style="color: white; margin: 0; font-size: 28px;">DC Store</h1>
          <p style="color: rgba(255,255,255,0.9); margin: 10px 0 0;">Order Confirmation</p>
        </div>
        
        <!-- Main Content -->
        <div style="background: white; padding: 30px; border-radius: 0 0 16px 16px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
          <!-- Success Message -->
          <div style="text-align: center; margin-bottom: 30px;">
            <div style="width: 60px; height: 60px; background: #10b981; border-radius: 50%; margin: 0 auto 15px; display: flex; align-items: center; justify-content: center;">
              <span style="color: white; font-size: 30px;">✓</span>
            </div>
            <h2 style="color: #333; margin: 0;">Thank you for your order!</h2>
            <p style="color: #666; margin: 10px 0 0;">Hi ${data.customerName}, your order has been received.</p>
          </div>
          
          <!-- Order Number -->
          <div style="background: #fef3c7; border: 1px solid #fcd34d; border-radius: 12px; padding: 15px; text-align: center; margin-bottom: 25px;">
            <p style="margin: 0; color: #92400e; font-size: 14px;">Order Number</p>
            <p style="margin: 5px 0 0; color: #78350f; font-size: 20px; font-weight: bold;">${data.orderNumber}</p>
          </div>
          
          <!-- Order Items -->
          <h3 style="color: #333; border-bottom: 2px solid #f59e0b; padding-bottom: 10px;">Order Items</h3>
          <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
            ${itemsHTML}
          </table>
          
          <!-- Order Summary -->
          <div style="background: #f9fafb; border-radius: 12px; padding: 20px; margin-bottom: 25px;">
            <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
              <span style="color: #666;">Subtotal:</span>
              <span style="color: #333;">৳${data.subtotal.toLocaleString()}</span>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
              <span style="color: #666;">Shipping:</span>
              <span style="color: ${data.shippingCost === 0 ? '#10b981' : '#333'};">
                ${data.shippingCost === 0 ? 'FREE' : `৳${data.shippingCost.toLocaleString()}`}
              </span>
            </div>
            <div style="display: flex; justify-content: space-between; border-top: 1px solid #e5e7eb; padding-top: 10px; margin-top: 10px;">
              <span style="color: #333; font-weight: bold; font-size: 18px;">Total:</span>
              <span style="color: #f59e0b; font-weight: bold; font-size: 18px;">৳${data.total.toLocaleString()}</span>
            </div>
          </div>
          
          <!-- Shipping Address -->
          <h3 style="color: #333; border-bottom: 2px solid #f59e0b; padding-bottom: 10px;">Shipping Address</h3>
          <div style="background: #f9fafb; border-radius: 12px; padding: 20px; margin-bottom: 25px;">
            <p style="margin: 0; color: #333;"><strong>${data.shippingAddress.name}</strong></p>
            <p style="margin: 5px 0 0; color: #666;">${data.shippingAddress.phone}</p>
            <p style="margin: 5px 0 0; color: #666;">${data.shippingAddress.address}</p>
            <p style="margin: 5px 0 0; color: #666;">${data.shippingAddress.city}, ${data.shippingAddress.state || ''}</p>
            <p style="margin: 5px 0 0; color: #666;">${data.shippingAddress.country}</p>
          </div>
          
          <!-- Payment Method -->
          <div style="background: #ecfdf5; border: 1px solid #10b981; border-radius: 12px; padding: 15px; text-align: center; margin-bottom: 25px;">
            <p style="margin: 0; color: #065f46; font-size: 14px;">Payment Method</p>
            <p style="margin: 5px 0 0; color: #047857; font-weight: bold;">
              ${data.paymentMethod === 'cod' ? '💵 Cash on Delivery' : data.paymentMethod}
            </p>
          </div>
          
          <!-- Track Order Button -->
          <div style="text-align: center; margin-bottom: 25px;">
            <a href="https://store.digitalcare.site/track-order" 
               style="display: inline-block; background: linear-gradient(135deg, #f59e0b, #ec4899); color: white; padding: 15px 40px; border-radius: 50px; text-decoration: none; font-weight: bold; font-size: 16px;">
              Track Your Order
            </a>
          </div>
          
          <!-- Contact Info -->
          <div style="text-align: center; padding: 20px; background: #f9fafb; border-radius: 12px;">
            <p style="margin: 0; color: #666; font-size: 14px;">
              Questions? Contact us at<br>
              <a href="mailto:rahmatullahzisan@gmail.com" style="color: #f59e0b;">rahmatullahzisan@gmail.com</a>
            </p>
          </div>
        </div>
        
        <!-- Footer -->
        <div style="text-align: center; padding: 20px; color: #666; font-size: 12px;">
          <p style="margin: 0;">© ${new Date().getFullYear()} DC Store. All rights reserved.</p>
          <p style="margin: 5px 0 0;">
            <a href="https://store.digitalcare.site" style="color: #f59e0b;">store.digitalcare.site</a>
          </p>
        </div>
      </div>
    </body>
    </html>
  `;
}

/**
 * Send order confirmation email
 */
export async function sendOrderConfirmationEmail(data: OrderEmailData): Promise<{ success: boolean; error?: string }> {
  if (!resend) {
    console.warn('Resend API key not configured. Skipping email send.');
    return { success: false, error: 'Email service not configured' };
  }

  if (!data.customerEmail) {
    console.warn('No customer email provided. Skipping email send.');
    return { success: false, error: 'No customer email' };
  }

  try {
    const { data: emailData, error } = await resend.emails.send({
      from: FROM_EMAIL,
      to: [data.customerEmail],
      subject: `Order Confirmed - ${data.orderNumber} | DC Store`,
      html: generateOrderConfirmationHTML(data),
    });

    if (error) {
      console.error('Resend error:', error);
      return { success: false, error: error.message };
    }

    console.log(`Order confirmation email sent: ${emailData?.id}`);
    return { success: true };
  } catch (error) {
    console.error('Error sending email:', error);
    return { success: false, error: String(error) };
  }
}

/**
 * Send order status update email
 */
export async function sendOrderStatusEmail(
  customerEmail: string,
  customerName: string,
  orderNumber: string,
  status: string
): Promise<{ success: boolean; error?: string }> {
  if (!resend || !customerEmail) {
    return { success: false, error: 'Email service not available or no email' };
  }

  const statusMessages: Record<string, { title: string; message: string; color: string }> = {
    confirmed: {
      title: 'Order Confirmed! ✅',
      message: 'Your order has been confirmed and is being prepared.',
      color: '#10b981',
    },
    processing: {
      title: 'Order Processing 📦',
      message: 'Your order is being processed and will be shipped soon.',
      color: '#3b82f6',
    },
    shipped: {
      title: 'Order Shipped! 🚚',
      message: 'Your order is on its way! You will receive it soon.',
      color: '#8b5cf6',
    },
    delivered: {
      title: 'Order Delivered! 🎉',
      message: 'Your order has been delivered. Thank you for shopping with us!',
      color: '#10b981',
    },
    cancelled: {
      title: 'Order Cancelled ❌',
      message: 'Your order has been cancelled. If you have any questions, please contact us.',
      color: '#ef4444',
    },
  };

  const statusInfo = statusMessages[status] || {
    title: `Order Update: ${status}`,
    message: `Your order status has been updated to ${status}.`,
    color: '#6b7280',
  };

  try {
    const { error } = await resend.emails.send({
      from: FROM_EMAIL,
      to: [customerEmail],
      subject: `${statusInfo.title} - ${orderNumber} | DC Store`,
      html: `
        <!DOCTYPE html>
        <html>
        <body style="margin: 0; padding: 20px; font-family: 'Segoe UI', sans-serif; background: #f5f5f5;">
          <div style="max-width: 500px; margin: 0 auto; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
            <div style="background: ${statusInfo.color}; padding: 30px; text-align: center;">
              <h1 style="color: white; margin: 0;">${statusInfo.title}</h1>
            </div>
            <div style="padding: 30px;">
              <p style="color: #333; font-size: 16px;">Hi ${customerName},</p>
              <p style="color: #666; font-size: 16px;">${statusInfo.message}</p>
              <div style="background: #f9fafb; border-radius: 12px; padding: 15px; margin: 20px 0; text-align: center;">
                <p style="margin: 0; color: #666; font-size: 14px;">Order Number</p>
                <p style="margin: 5px 0 0; color: #333; font-size: 18px; font-weight: bold;">${orderNumber}</p>
              </div>
              <div style="text-align: center;">
                <a href="https://store.digitalcare.site/track-order" 
                   style="display: inline-block; background: ${statusInfo.color}; color: white; padding: 12px 30px; border-radius: 50px; text-decoration: none; font-weight: bold;">
                  Track Order
                </a>
              </div>
            </div>
          </div>
        </body>
        </html>
      `,
    });

    if (error) {
      return { success: false, error: error.message };
    }
    return { success: true };
  } catch (error) {
    return { success: false, error: String(error) };
  }
}
