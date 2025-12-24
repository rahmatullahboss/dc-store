"use client";

import { useState } from "react";
import Link from "next/link";
import { 
  Mail, 
  Phone, 
  MapPin, 
  Clock, 
  Send, 
  Loader2, 
  CheckCircle, 
  MessageSquare,
  Facebook,
  Instagram,
  ArrowRight,
  Headphones
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Alert, AlertDescription } from "@/components/ui/alert";

const contactMethods = [
  {
    icon: Phone,
    title: "Call Us",
    description: "Mon-Sat, 10am-8pm",
    value: "+880 1XXX XXXXXX",
    href: "tel:+8801XXXXXXXXX",
  },
  {
    icon: Mail,
    title: "Email Us",
    description: "We'll reply within 24h",
    value: "support@dcstore.com",
    href: "mailto:support@dcstore.com",
  },
  {
    icon: MessageSquare,
    title: "Live Chat",
    description: "Chat with our team",
    value: "Start a conversation",
    href: "#",
  },
  {
    icon: MapPin,
    title: "Visit Us",
    description: "Our main office",
    value: "Dhanmondi, Dhaka",
    href: "#",
  },
];

const socialLinks = [
  { name: "Facebook", icon: Facebook, href: "#" },
  { name: "Instagram", icon: Instagram, href: "#" },
];

export default function ContactPage() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    subject: "",
    message: "",
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);
  const [error, setError] = useState("");

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData((prev) => ({
      ...prev,
      [e.target.name]: e.target.value,
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    if (!formData.name || !formData.email || !formData.message) {
      setError("Please fill in all required fields");
      return;
    }

    setIsSubmitting(true);

    // Simulate API call
    setTimeout(() => {
      setIsSubmitting(false);
      setIsSuccess(true);
      setFormData({ name: "", email: "", phone: "", subject: "", message: "" });
    }, 1500);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-amber-50 via-white to-rose-50">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/30 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/30 blur-3xl" />
      </div>

      <div className="relative z-10">
        {/* Hero Section */}
        <section className="container mx-auto px-4 pt-12 pb-8">
          <div className="text-center max-w-2xl mx-auto">
            <div className="w-20 h-20 mx-auto bg-gradient-to-r from-amber-400 to-rose-400 rounded-2xl flex items-center justify-center mb-6 shadow-md shadow-amber-300/20">
              <Headphones className="w-10 h-10 text-white" />
            </div>
            <h1 className="text-4xl sm:text-5xl font-bold text-gray-800 mb-4">
              We&apos;re Here to <span className="brand-text">Help</span>
            </h1>
            <p className="text-lg text-gray-600">
              Have a question or need assistance? Our team is ready to help you with anything you need.
            </p>
          </div>
        </section>

        {/* Contact Methods */}
        <section className="container mx-auto px-4 pb-12">
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 max-w-5xl mx-auto">
            {contactMethods.map((method) => (
              <a
                key={method.title}
                href={method.href}
                className="group"
              >
                <Card className="h-full bg-white/80 backdrop-blur border-0 shadow-lg hover:shadow-xl transition-all duration-300 hover:-translate-y-1">
                  <CardContent className="p-5 text-center">
                    <div className="w-14 h-14 mx-auto bg-gradient-to-r from-amber-400 to-rose-400 rounded-xl flex items-center justify-center mb-4 group-hover:scale-110 transition-transform shadow-md">
                      <method.icon className="w-7 h-7 text-white" />
                    </div>
                    <h3 className="font-bold text-gray-800 mb-1">{method.title}</h3>
                    <p className="text-xs text-gray-500 mb-2">{method.description}</p>
                    <p className="text-sm font-medium text-gray-700 group-hover:text-amber-600 transition-colors">
                      {method.value}
                    </p>
                  </CardContent>
                </Card>
              </a>
            ))}
          </div>
        </section>

        {/* Main Content */}
        <section className="container mx-auto px-4 pb-16">
          <div className="grid lg:grid-cols-5 gap-8 max-w-6xl mx-auto">
            {/* Contact Form - Takes 3 columns */}
            <div className="lg:col-span-3 space-y-6">
              <Card className="bg-white/90 backdrop-blur border-0 shadow-xl overflow-hidden">
                <div className="bg-gradient-to-r from-amber-500 to-rose-500 p-6 text-white">
                  <h2 className="text-2xl font-bold mb-2">Send us a Message</h2>
                  <p className="text-white/80">
                    Fill out the form and we&apos;ll get back to you within 24 hours.
                  </p>
                </div>
                <CardContent className="p-6">
                  {isSuccess ? (
                    <div className="text-center py-12">
                      <div className="w-20 h-20 mx-auto bg-gradient-to-r from-amber-400 to-rose-500 rounded-full flex items-center justify-center mb-6">
                        <CheckCircle className="w-10 h-10 text-white" />
                      </div>
                      <h3 className="text-2xl font-bold text-gray-800 mb-3">Message Sent!</h3>
                      <p className="text-gray-500 mb-6 max-w-sm mx-auto">
                        Thank you for reaching out. Our team will get back to you within 24 hours.
                      </p>
                      <Button
                        onClick={() => setIsSuccess(false)}
                        className="bg-gradient-to-r from-amber-500 to-rose-500 text-white"
                      >
                        Send Another Message
                      </Button>
                    </div>
                  ) : (
                    <form onSubmit={handleSubmit} className="space-y-5">
                      {error && (
                        <Alert variant="destructive">
                          <AlertDescription>{error}</AlertDescription>
                        </Alert>
                      )}

                      <div className="grid sm:grid-cols-2 gap-4">
                        <div className="space-y-2">
                          <label className="text-sm font-medium text-gray-700">
                            Name <span className="text-red-500">*</span>
                          </label>
                          <Input
                            name="name"
                            value={formData.name}
                            onChange={handleChange}
                            placeholder="Your full name"
                            className="bg-gray-50 border-gray-200 focus:bg-white transition-colors"
                            required
                          />
                        </div>
                        <div className="space-y-2">
                          <label className="text-sm font-medium text-gray-700">
                            Email <span className="text-red-500">*</span>
                          </label>
                          <Input
                            name="email"
                            type="email"
                            value={formData.email}
                            onChange={handleChange}
                            placeholder="your@email.com"
                            className="bg-gray-50 border-gray-200 focus:bg-white transition-colors"
                            required
                          />
                        </div>
                      </div>

                      <div className="grid sm:grid-cols-2 gap-4">
                        <div className="space-y-2">
                          <label className="text-sm font-medium text-gray-700">Phone</label>
                          <Input
                            name="phone"
                            type="tel"
                            value={formData.phone}
                            onChange={handleChange}
                            placeholder="+880 1XXX XXXXXX"
                            className="bg-gray-50 border-gray-200 focus:bg-white transition-colors"
                          />
                        </div>
                        <div className="space-y-2">
                          <label className="text-sm font-medium text-gray-700">Subject</label>
                          <Input
                            name="subject"
                            value={formData.subject}
                            onChange={handleChange}
                            placeholder="How can we help?"
                            className="bg-gray-50 border-gray-200 focus:bg-white transition-colors"
                          />
                        </div>
                      </div>

                      <div className="space-y-2">
                        <label className="text-sm font-medium text-gray-700">
                          Message <span className="text-red-500">*</span>
                        </label>
                        <Textarea
                          name="message"
                          value={formData.message}
                          onChange={handleChange}
                          placeholder="Tell us more about your inquiry..."
                          rows={5}
                          className="bg-gray-50 border-gray-200 focus:bg-white transition-colors resize-none"
                          required
                        />
                      </div>

                      <Button
                        type="submit"
                        className="w-full bg-gradient-to-r from-amber-500 to-rose-500 hover:from-amber-600 hover:to-rose-600 text-white font-semibold py-6 text-lg gap-2"
                        disabled={isSubmitting}
                      >
                        {isSubmitting ? (
                          <>
                            <Loader2 className="h-5 w-5 animate-spin" />
                            Sending...
                          </>
                        ) : (
                          <>
                            <Send className="h-5 w-5" />
                            Send Message
                          </>
                        )}
                      </Button>
                    </form>
                  )}
                </CardContent>
              </Card>

              {/* Follow Us - Now under the form on left side */}
              <Card className="bg-gradient-to-r from-amber-400/90 to-rose-400/90 border-0 shadow-md">
                <CardContent className="p-6 text-white">
                  <div className="flex items-center justify-between">
                    <div>
                      <h3 className="font-bold text-lg mb-1">Follow Us</h3>
                      <p className="text-sm text-white/80">
                        Stay connected for updates and offers!
                      </p>
                    </div>
                    <div className="flex gap-3">
                      {socialLinks.map((social) => (
                        <a
                          key={social.name}
                          href={social.href}
                          className="w-10 h-10 bg-white/20 rounded-lg flex items-center justify-center hover:bg-white hover:text-amber-600 transition-all"
                        >
                          <social.icon className="w-5 h-5" />
                        </a>
                      ))}
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* Sidebar - Takes 2 columns */}
            <div className="lg:col-span-2 space-y-6">
              {/* Business Hours */}
              <Card className="bg-white/80 backdrop-blur border-0 shadow-lg">
                <CardContent className="p-6">
                  <div className="flex items-center gap-3 mb-4">
                    <div className="p-2 bg-gradient-to-r from-amber-100 to-rose-100 rounded-lg">
                      <Clock className="w-5 h-5 text-amber-600" />
                    </div>
                    <h3 className="font-bold text-gray-800">Business Hours</h3>
                  </div>
                  <div className="space-y-3">
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-600">Saturday - Thursday</span>
                      <span className="font-medium text-gray-800">10:00 AM - 8:00 PM</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-600">Friday</span>
                      <span className="font-medium text-rose-500">Closed</span>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* Quick Links */}
              <Card className="bg-white/80 backdrop-blur border-0 shadow-lg">
                <CardContent className="p-6">
                  <h3 className="font-bold text-gray-800 mb-4">Quick Links</h3>
                  <div className="space-y-3">
                    <Link href="/faq" className="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-amber-50 transition-colors group">
                      <span className="text-sm text-gray-700">Frequently Asked Questions</span>
                      <ArrowRight className="w-4 h-4 text-gray-400 group-hover:text-amber-500 transition-colors" />
                    </Link>
                    <Link href="/returns" className="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-amber-50 transition-colors group">
                      <span className="text-sm text-gray-700">Returns & Shipping</span>
                      <ArrowRight className="w-4 h-4 text-gray-400 group-hover:text-amber-500 transition-colors" />
                    </Link>
                    <Link href="/track-order" className="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-amber-50 transition-colors group">
                      <span className="text-sm text-gray-700">Track Your Order</span>
                      <ArrowRight className="w-4 h-4 text-gray-400 group-hover:text-amber-500 transition-colors" />
                    </Link>
                  </div>
                </CardContent>
              </Card>

              {/* Map Placeholder */}
              <Card className="bg-white/80 backdrop-blur border-0 shadow-lg overflow-hidden">
                <div className="h-48 bg-gradient-to-br from-amber-50 to-rose-50 flex items-center justify-center relative">
                  <div className="relative text-center z-10">
                    <MapPin className="w-10 h-10 text-amber-500 mx-auto mb-2 drop-shadow-lg" />
                    <p className="text-sm font-medium text-gray-700">Dhanmondi, Dhaka</p>
                    <p className="text-xs text-gray-500">Bangladesh</p>
                  </div>
                </div>
              </Card>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}
