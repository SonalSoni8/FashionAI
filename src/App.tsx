import React, { useState, useRef, useEffect } from 'react';
import { 
  Sparkles, Camera, Shirt, Calendar, Luggage, ShoppingBag, 
  User, CheckCircle, ArrowRight, Sun, MessageSquare, 
  Layers, Sliders, RefreshCw, Send, Lock, Mail, ExternalLink, Flame,
  Video, Upload, AlertCircle, Palette, Activity, Check, ChevronRight, LogOut
} from 'lucide-react';

export default function App() {
  // App View State: 'auth' | 'setup' | 'main'
  const [appState, setAppState] = useState<'auth' | 'setup' | 'main'>('auth');
  const [setupStep, setSetupStep] = useState<number>(1);

  // Main Workspace Tab State
  const [currentTab, setCurrentTab] = useState<'dashboard' | 'skin-scanner' | 'body-scanner' | 'ai-stylist' | 'wardrobe' | 'occasions' | 'packing' | 'shopping'>('dashboard');
  
  // User Authentication Form State
  const [authMode, setAuthMode] = useState<'login' | 'signup'>('login');
  const [email, setEmail] = useState('alex.morgan@aura.ai');
  const [password, setPassword] = useState('••••••••••••');
  const [authError, setAuthError] = useState<string | null>(null);

  // User Profile Account Setup State
  const [userName, setUserName] = useState('Alex Morgan');
  const [userGender, setUserGender] = useState<'female' | 'male' | 'unisex'>('female');
  const [age, setAge] = useState(26);
  const [styleAesthetic, setStyleAesthetic] = useState('Quiet Luxury Minimalist');
  const [height, setHeight] = useState(172);
  const [weight, setWeight] = useState(62);
  const [clothingSize, setClothingSize] = useState('M');
  const [shoeSize, setShoeSize] = useState('38 EU / 7.5 US');
  const [fitPreference, setFitPreference] = useState('Tailored Slim');
  const [city, setCity] = useState('New York');
  const [climate, setClimate] = useState('Temperate Four-Season');

  // Real Camera & Photo States
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const [cameraActive, setCameraActive] = useState(false);
  const [cameraError, setCameraError] = useState<string | null>(null);
  const [isScanning, setIsScanning] = useState(false);
  
  const [skinSelfieImage, setSkinSelfieImage] = useState<string | null>(null);
  const [fullBodyImage, setFullBodyImage] = useState<string | null>(null);

  // Female Outfit Recommendations Dataset
  const femaleOutfits = [
    {
      title: "Structured Linen Trench + Belted Midi Dress",
      description: "Creates defined waist cinch while soft trench lapels complement shoulder structure.",
      suitability: "98% Match for Hourglass",
      imageUrl: "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=800&q=80",
      items: ["Beige Wool-Linen Trench", "Emerald Silk Belted Midi Dress", "Nude Pointed Pumps", "Rose Gold Pendant"]
    },
    {
      title: "Monochromatic Silk Blouse + Tailored High-Waist Trousers",
      description: "Elongates torso length while high rise trouser waistline highlights feminine proportions.",
      suitability: "96% Match for Hourglass",
      imageUrl: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=800&q=80",
      items: ["Off-White V-Neck Silk Blouse", "Tailored Charcoal High-Waist Pants", "Espresso Leather Mules", "Gold Hoop Earrings"]
    },
    {
      title: "Elegantly Draped Cashmere Knit + Pleated Satin Skirt",
      description: "Soft draped neckline softens collarbone definition with fluid movement across hips.",
      suitability: "95% Match for Hourglass",
      imageUrl: "https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=800&q=80",
      items: ["Cream Cashmere Crewneck", "Champagne Satin Pleated Skirt", "Taupe Ankle Boots", "Minimalist Pearl Bracelet"]
    }
  ];

  // Male Outfit Recommendations Dataset
  const maleOutfits = [
    {
      title: "Unstructured Charcoal Linen Blazer + Supima Tee",
      description: "Soft unstructured shoulders balance shoulder width while slim trousers highlight leg proportions.",
      suitability: "98% Match for V-Shape",
      imageUrl: "https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=800&q=80",
      items: ["Charcoal Wool-Linen Blazer", "Off-White Supima Cotton Crewneck", "Dark Slate Trousers", "Calfskin White Sneakers"]
    },
    {
      title: "Open-Collar Silk-Linen Shirt + Tailored Slate Trousers",
      description: "Vertical collar placket creates elongating lines. Tapered rise trousers balance upper torso width.",
      suitability: "96% Match for V-Shape",
      imageUrl: "https://images.unsplash.com/photo-1617137984095-74e4e5e3613f?auto=format&fit=crop&w=800&q=80",
      items: ["Olive-Emerald Silk Knit Shirt", "Tailored Slate Stretch Pants", "Espresso Suede Belt", "Silver Dial Chronograph"]
    },
    {
      title: "Double-Breasted Beige Suit + Espresso Loafers",
      description: "Lapel width aligns precisely with outer shoulder points, giving clean structural flow.",
      suitability: "95% Match for V-Shape",
      imageUrl: "https://images.unsplash.com/photo-1594938298603-c8148c4dae35?auto=format&fit=crop&w=800&q=80",
      items: ["Sand Beige Wool Blend Suit", "Crisp White Oxford Shirt", "Espresso Leather Loafers", "Tortoise Acetate Sunglasses"]
    }
  ];

  // Unisex Outfit Recommendations Dataset
  const unisexOutfits = [
    {
      title: "Oversized Cashmere Crewneck + Wide-Leg Slate Trousers",
      description: "Clean gender-neutral silhouette with soft shoulders and fluid leg drape.",
      suitability: "97% Match for Neutral Flow",
      imageUrl: "https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?auto=format&fit=crop&w=800&q=80",
      items: ["Heather Grey Cashmere Crew", "Wide-Leg Slate Trousers", "White Leather Court Sneakers", "Minimalist Silver Ring"]
    },
    {
      title: "Minimalist Cream Wool Coat + Tapered Black Pants",
      description: "Timeless architectural lines providing effortless luxury across all body silhouettes.",
      suitability: "95% Match for Neutral Flow",
      imageUrl: "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?auto=format&fit=crop&w=800&q=80",
      items: ["Cream Double-Faced Wool Coat", "Tapered Black Stretch Pants", "Black Leather Chelsea Boots"]
    }
  ];

  // Dynamic Outfit Recommendations Selection Based on Profile Setup Gender Choice
  const getOutfitsForGender = () => {
    if (userGender === 'female') return femaleOutfits;
    if (userGender === 'male') return maleOutfits;
    return unisexOutfits;
  };

  // Dynamic Skin Tone Results
  const skinScanDone = true;
  const skinResult = {
    detectedTone: "Warm Olive (Level 3)",
    undertone: "Golden Warm",
    paletteName: userGender === 'female' ? "Soft Autumn / Warm Elegance" : "Deep Autumn / Cool Winter",
    powerColors: userGender === 'female' ? [
      { name: "Emerald Silk", hex: "#0F766E" },
      { name: "Rose Quartz", hex: "#E11D48" },
      { name: "Deep Sapphire", hex: "#4338CA" },
      { name: "Warm Terracotta", hex: "#C2410C" }
    ] : [
      { name: "Teal Emerald", hex: "#0F766E" },
      { name: "Deep Sapphire", hex: "#4338CA" },
      { name: "Charcoal Slate", hex: "#1E293B" },
      { name: "Crimson Wine", hex: "#BE123C" }
    ],
    avoidColors: [
      { name: "Muted Mustard", hex: "#D97706" },
      { name: "Pale Salmon", hex: "#FB7185" }
    ],
    recommendedMetals: userGender === 'female' ? ["Rose Gold", "Warm Yellow Gold", "Brushed Platinum"] : ["Brushed Platinum", "Brushed Silver", "Matte Black"],
    reasoning: userGender === 'female' 
      ? "Analysis of your selfie detected a warm olive undertone. Emerald silk and rose quartz highlight natural glowing skin tones, paired best with rose gold jewelry."
      : "Analysis of your selfie detected a warm olive undertone. Deep sapphire and charcoal slate bring out sharp jawline definition, while muted mustard should be avoided."
  };

  // Dynamic Body Results
  const bodyScanDone = true;
  const bodyResult = {
    bodyShape: userGender === 'female' 
      ? "Hourglass Silhouette (Defined Waist & Balanced Bust/Hips)" 
      : userGender === 'male' 
      ? "Athletic V-Shape (Broad Shoulders, Tapered Waist)" 
      : "Classic Fluid Silhouette",
    shoulderRatio: userGender === 'female' ? "1.02 Balanced Proportion Ratio" : "1.28 Ratio (High Angular Symmetry)",
    heightEstimate: `${height} cm`,
    recommendedOutfits: getOutfitsForGender()
  };

  // Chat State
  const [chatInput, setChatInput] = useState('');
  const [messages, setMessages] = useState([
    { text: "Welcome to Aura AI! I have tailored your styling profile based on your gender selection. Ask me any outfit, dress code, or color pairing question.", isUser: false }
  ]);

  // Start Web Camera Stream
  const startCamera = async () => {
    setCameraError(null);
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { width: { ideal: 1280 }, height: { ideal: 720 }, facingMode: 'user' }
      });
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        videoRef.current.play();
        setCameraActive(true);
      }
    } catch (err: any) {
      setCameraError("Camera permission denied or camera unavailable. Please upload your photo file.");
      setCameraActive(false);
    }
  };

  // Stop Camera Stream
  const stopCamera = () => {
    if (videoRef.current && videoRef.current.srcObject) {
      const stream = videoRef.current.srcObject as MediaStream;
      stream.getTracks().forEach(track => track.stop());
      videoRef.current.srcObject = null;
    }
    setCameraActive(false);
  };

  // Capture Snapshot
  const capturePhotoForTab = (tab: 'skin-scanner' | 'body-scanner') => {
    if (videoRef.current && canvasRef.current) {
      const video = videoRef.current;
      const canvas = canvasRef.current;
      canvas.width = video.videoWidth || 640;
      canvas.height = video.videoHeight || 480;
      const ctx = canvas.getContext('2d');
      if (ctx) {
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
        const dataUrl = canvas.toDataURL('image/jpeg');
        if (tab === 'skin-scanner') {
          setSkinSelfieImage(dataUrl);
        } else {
          setFullBodyImage(dataUrl);
        }
        stopCamera();
      }
    }
  };

  // Handle Photo Uploads
  const handleSkinSelfieUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const reader = new FileReader();
      reader.onload = (ev) => ev.target?.result && setSkinSelfieImage(ev.target.result as string);
      reader.readAsDataURL(e.target.files[0]);
    }
  };

  const handleFullBodyUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const reader = new FileReader();
      reader.onload = (ev) => ev.target?.result && setFullBodyImage(ev.target.result as string);
      reader.readAsDataURL(e.target.files[0]);
    }
  };

  // Auth Handler
  const handleAuthSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !password) {
      setAuthError('Please enter a valid email and password');
      return;
    }
    setAuthError(null);
    setAppState('setup');
    setSetupStep(1);
  };

  const handleSendMessage = (textToSend?: string) => {
    const query = textToSend || chatInput;
    if (!query.trim()) return;
    setMessages(prev => [...prev, { text: query, isUser: true }]);
    if (!textToSend) setChatInput('');

    setTimeout(() => {
      let reply = `Aura AI Recommendation (${userGender.toUpperCase()}): Focus on color contrast and silhouette harmony. Emerald silk, rose quartz, and deep sapphire bring out your glowing undertone.`;
      if (query.toLowerCase().includes("interview")) {
        reply = userGender === 'female' 
          ? "For a high-impact executive interview, pair a structured navy wool blazer with a silk cream top, tailored high-waist trousers, and nude leather pumps."
          : "For a modern executive interview, pair an unstructured navy wool blazer over an off-white silk crewneck shirt, slim charcoal trousers, and clean dress sneakers.";
      }
      setMessages(prev => [...prev, { text: reply, isUser: false }]);
    }, 1000);
  };

  useEffect(() => {
    return () => {
      stopCamera();
    };
  }, []);

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#090A0F', color: '#F9FAFB', fontFamily: 'system-ui, sans-serif' }}>
      <canvas ref={canvasRef} style={{ display: 'none' }} />

      {/* ======================================================== */}
      {/* 1. AUTHENTICATION SCREEN (LOGIN / SIGNUP) */}
      {/* ======================================================== */}
      {appState === 'auth' && (
        <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'radial-gradient(circle at 50% 30%, rgba(99, 102, 241, 0.15), transparent 70%), #090A0F', padding: '24px' }}>
          <div className="glass-card glowing" style={{ width: '100%', maxWidth: '440px', padding: '40px', borderRadius: '32px', textAlign: 'center' }}>
            
            <div style={{ width: '56px', height: '56px', borderRadius: '18px', background: 'linear-gradient(135deg, #6366F1, #EC4899)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 20px auto' }}>
              <Sparkles size={28} color="#FFF" />
            </div>

            <h1 style={{ margin: '0 0 6px 0', fontSize: '26px', fontWeight: 800, letterSpacing: '1px' }}>AURA AI</h1>
            <p style={{ color: '#9CA3AF', fontSize: '14px', margin: '0 0 32px 0' }}>Your Personal AI Stylist & Wardrobe Ecosystem</p>

            {/* Social OAuth Buttons */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px', marginBottom: '24px' }}>
              <button className="morph-btn morph-btn-outline" style={{ width: '100%', justifyContent: 'center' }} onClick={() => { setAppState('setup'); setSetupStep(1); }}>
                Continue with Apple
              </button>
              <button className="morph-btn morph-btn-outline" style={{ width: '100%', justifyContent: 'center' }} onClick={() => { setAppState('setup'); setSetupStep(1); }}>
                Continue with Google
              </button>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: '16px', margin: '24px 0' }}>
              <hr style={{ flex: 1, borderColor: 'rgba(255,255,255,0.1)' }} />
              <span style={{ fontSize: '11px', color: '#6B7280', fontWeight: 700 }}>OR WITH EMAIL</span>
              <hr style={{ flex: 1, borderColor: 'rgba(255,255,255,0.1)' }} />
            </div>

            <form onSubmit={handleAuthSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '16px', textAlign: 'left' }}>
              <div>
                <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>EMAIL ADDRESS</label>
                <input 
                  type="email" 
                  value={email} 
                  onChange={(e) => setEmail(e.target.value)} 
                  required
                  style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                />
              </div>

              <div>
                <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>PASSWORD</label>
                <input 
                  type="password" 
                  value={password} 
                  onChange={(e) => setPassword(e.target.value)} 
                  required
                  style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                />
              </div>

              {authError && (
                <span style={{ fontSize: '13px', color: '#EF4444' }}>{authError}</span>
              )}

              <button type="submit" className="morph-btn" style={{ width: '100%', justifyContent: 'center', padding: '16px', fontSize: '16px', marginTop: '8px' }}>
                {authMode === 'login' ? 'Sign In to Aura AI' : 'Create Free Account'} <ArrowRight size={18} />
              </button>
            </form>

            <p style={{ margin: '24px 0 0 0', fontSize: '13px', color: '#9CA3AF' }}>
              {authMode === 'login' ? "Don't have an account? " : "Already have an account? "}
              <button 
                onClick={() => setAuthMode(authMode === 'login' ? 'signup' : 'login')}
                style={{ background: 'none', border: 'none', color: '#6366F1', fontWeight: 700, cursor: 'pointer', padding: 0 }}
              >
                {authMode === 'login' ? 'Sign Up' : 'Sign In'}
              </button>
            </p>

          </div>
        </div>
      )}

      {/* ======================================================== */}
      {/* 2. ACCOUNT SETUP ONBOARDING PIPELINE */}
      {/* ======================================================== */}
      {appState === 'setup' && (
        <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '40px 24px', background: 'radial-gradient(circle at 50% 20%, rgba(236, 72, 153, 0.12), transparent 70%), #090A0F' }}>
          
          {/* Progress Header Bar */}
          <div style={{ width: '100%', maxWidth: '680px', marginBottom: '32px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '12px' }}>
              <span style={{ fontSize: '12px', fontWeight: 800, color: '#6366F1', letterSpacing: '1px' }}>ACCOUNT SETUP · STEP {setupStep} OF 4</span>
              <span style={{ fontSize: '12px', color: '#9CA3AF' }}>{setupStep * 25}% Complete</span>
            </div>
            <div style={{ width: '100%', height: '6px', borderRadius: '4px', backgroundColor: 'rgba(255,255,255,0.1)', overflow: 'hidden' }}>
              <div style={{ width: `${setupStep * 25}%`, height: '100%', background: 'linear-gradient(90deg, #6366F1, #EC4899)', transition: 'width 0.4s ease' }} />
            </div>
          </div>

          <div className="glass-card glowing" style={{ width: '100%', maxWidth: '680px', padding: '40px', borderRadius: '32px' }}>
            
            {/* STEP 1: PERSONAL IDENTITY & GENDER */}
            {setupStep === 1 && (
              <div>
                <h2 style={{ fontSize: '28px', margin: '0 0 8px 0' }}>Tell Us About Yourself</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '28px' }}>Your gender preference directly configures your tailored outfit recommendations.</p>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
                  <div>
                    <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>YOUR NAME</label>
                    <input 
                      type="text" 
                      value={userName} 
                      onChange={(e) => setUserName(e.target.value)} 
                      style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                    />
                  </div>

                  <div>
                    <label style={{ fontSize: '12px', color: '#6366F1', fontWeight: 800, display: 'block', marginBottom: '8px', letterSpacing: '1px' }}>GENDER STYLING PROFILE (TAILORS ALL OUTFITS)</label>
                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '10px' }}>
                      {[
                        { id: 'female', label: '👩 Female Outfits' },
                        { id: 'male', label: '👨 Male Outfits' },
                        { id: 'unisex', label: '✨ Unisex Outfits' }
                      ].map((g) => (
                        <button
                          key={g.id}
                          type="button"
                          onClick={() => setUserGender(g.id as any)}
                          style={{
                            padding: '16px 12px', borderRadius: '16px', border: '1px solid',
                            borderColor: userGender === g.id ? '#6366F1' : 'rgba(255,255,255,0.1)',
                            backgroundColor: userGender === g.id ? 'rgba(99,102,241,0.25)' : 'rgba(255,255,255,0.02)',
                            color: userGender === g.id ? '#FFF' : '#9CA3AF',
                            fontWeight: 700, fontSize: '13px', cursor: 'pointer', transition: 'all 0.2s ease'
                          }}
                        >
                          {g.label}
                        </button>
                      ))}
                    </div>
                  </div>

                  <div>
                    <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>PREFERRED STYLE AESTHETIC</label>
                    <select 
                      value={styleAesthetic}
                      onChange={(e) => setStyleAesthetic(e.target.value)}
                      style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: '#12141C', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                    >
                      <option value="Quiet Luxury Minimalist">Quiet Luxury Minimalist (Apple + Notion)</option>
                      <option value="Old Money Tailored">Old Money Tailored Executive</option>
                      <option value="Streetwear High-Fashion">Modern Streetwear & High Fashion</option>
                      <option value="Smart Casual Chic">Smart Casual Chic</option>
                    </select>
                  </div>
                </div>

                <button className="morph-btn" style={{ width: '100%', justifyContent: 'center', marginTop: '32px', padding: '16px' }} onClick={() => setSetupStep(2)}>
                  Continue to Measurements & Sizing <ChevronRight size={18} />
                </button>
              </div>
            )}

            {/* STEP 2: MEASUREMENTS & SIZING */}
            {setupStep === 2 && (
              <div>
                <h2 style={{ fontSize: '28px', margin: '0 0 8px 0' }}>Sizing & Proportions</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '28px' }}>Ensures garment drape, rise, and sleeve cuffs fit perfectly.</p>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '20px' }}>
                  <div>
                    <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>HEIGHT (CM)</label>
                    <input 
                      type="number" 
                      value={height} 
                      onChange={(e) => setHeight(Number(e.target.value))} 
                      style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                    />
                  </div>

                  <div>
                    <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>WEIGHT (KG)</label>
                    <input 
                      type="number" 
                      value={weight} 
                      onChange={(e) => setWeight(Number(e.target.value))} 
                      style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                    />
                  </div>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '20px' }}>
                  <div>
                    <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>CLOTHING SIZE</label>
                    <select 
                      value={clothingSize}
                      onChange={(e) => setClothingSize(e.target.value)}
                      style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: '#12141C', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                    >
                      <option value="XS">Extra Small (XS)</option>
                      <option value="S">Small (S)</option>
                      <option value="M">Medium (M)</option>
                      <option value="L">Large (L)</option>
                      <option value="XL">Extra Large (XL)</option>
                    </select>
                  </div>

                  <div>
                    <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>FIT CUT PREFERENCE</label>
                    <select 
                      value={fitPreference}
                      onChange={(e) => setFitPreference(e.target.value)}
                      style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: '#12141C', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                    >
                      <option value="Tailored Slim">Tailored Slim Fit</option>
                      <option value="Relaxed Oversized">Relaxed Oversized Fit</option>
                      <option value="Classic Regular">Classic Regular Fit</option>
                    </select>
                  </div>
                </div>

                <div style={{ display: 'flex', gap: '12px', marginTop: '32px' }}>
                  <button className="morph-btn morph-btn-outline" style={{ flex: 1, justifyContent: 'center' }} onClick={() => setSetupStep(1)}>
                    Back
                  </button>
                  <button className="morph-btn" style={{ flex: 2, justifyContent: 'center' }} onClick={() => setSetupStep(3)}>
                    Continue to Location & Weather <ChevronRight size={18} />
                  </button>
                </div>
              </div>
            )}

            {/* STEP 3: LOCATION & CLIMATE */}
            {setupStep === 3 && (
              <div>
                <h2 style={{ fontSize: '28px', margin: '0 0 8px 0' }}>Location & Climate Context</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '28px' }}>Allows Aura AI to check local daily weather for garment fabric recommendations.</p>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
                  <div>
                    <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>PRIMARY CITY</label>
                    <input 
                      type="text" 
                      value={city} 
                      onChange={(e) => setCity(e.target.value)} 
                      style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                    />
                  </div>

                  <div>
                    <label style={{ fontSize: '12px', color: '#9CA3AF', fontWeight: 700, display: 'block', marginBottom: '6px' }}>CLIMATE CONTEXT</label>
                    <select 
                      value={climate}
                      onChange={(e) => setClimate(e.target.value)}
                      style={{ width: '100%', padding: '14px 16px', borderRadius: '16px', background: '#12141C', border: '1px solid rgba(255,255,255,0.12)', color: '#FFF', fontSize: '15px' }}
                    >
                      <option value="Temperate Four-Season">Temperate (Four Seasons)</option>
                      <option value="Warm Mediterranean">Warm Mediterranean / Coastal</option>
                      <option value="Tropical Humid">Tropical Humid / Warm</option>
                      <option value="Cold Continental">Cold Continental / Alpine</option>
                    </select>
                  </div>
                </div>

                <div style={{ display: 'flex', gap: '12px', marginTop: '32px' }}>
                  <button className="morph-btn morph-btn-outline" style={{ flex: 1, justifyContent: 'center' }} onClick={() => setSetupStep(2)}>
                    Back
                  </button>
                  <button className="morph-btn" style={{ flex: 2, justifyContent: 'center' }} onClick={() => setSetupStep(4)}>
                    Proceed to AI Photo Scans <ChevronRight size={18} />
                  </button>
                </div>
              </div>
            )}

            {/* STEP 4: AI PHOTO UPLOADS & GENDER-MATCHED OUTFIT PREVIEW */}
            {setupStep === 4 && (
              <div>
                <h2 style={{ fontSize: '28px', margin: '0 0 8px 0' }}>AI Photo Scans & Outfit Preview</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '24px' }}>
                  Your selected gender profile (<strong style={{ color: '#EC4899' }}>{userGender.toUpperCase()}</strong>) has generated your visual outfit recommendations.
                </p>

                {/* GENDER-MATCHED TAILORED OUTFIT PREVIEW CARD */}
                <div style={{ borderRadius: '20px', background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(236, 72, 153, 0.3)', overflow: 'hidden', marginBottom: '24px' }}>
                  <div style={{ padding: '12px 16px', background: 'rgba(236, 72, 153, 0.15)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <span style={{ fontSize: '11px', color: '#EC4899', fontWeight: 800, letterSpacing: '1px' }}>
                      TAILORED OUTFIT MATCH FOR {userGender.toUpperCase()}
                    </span>
                    <span style={{ fontSize: '11px', color: '#10B981', fontWeight: 800 }}>{getOutfitsForGender()[0].suitability}</span>
                  </div>
                  <div style={{ display: 'flex', gap: '16px', padding: '16px', alignItems: 'center' }}>
                    <img src={getOutfitsForGender()[0].imageUrl} alt="Outfit Preview" style={{ width: '90px', height: '90px', borderRadius: '14px', objectFit: 'cover' }} />
                    <div>
                      <h4 style={{ margin: '0 0 4px 0', fontSize: '15px', fontWeight: 700 }}>{getOutfitsForGender()[0].title}</h4>
                      <p style={{ margin: 0, fontSize: '13px', color: '#9CA3AF', lineHeight: 1.4 }}>{getOutfitsForGender()[0].description}</p>
                    </div>
                  </div>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px', marginBottom: '28px' }}>
                  
                  {/* Selfie Photo Card */}
                  <div style={{ padding: '20px', borderRadius: '20px', background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.1)', textAlign: 'center' }}>
                    <Flame size={28} color="#6366F1" style={{ marginBottom: '10px' }} />
                    <h4 style={{ margin: '0 0 4px 0', fontSize: '15px' }}>1. Close-Up Selfie</h4>
                    <p style={{ margin: '0 0 14px 0', fontSize: '12px', color: '#9CA3AF' }}>Skin tone & power colors.</p>

                    <label className="morph-btn morph-btn-outline" style={{ width: '100%', justifyContent: 'center', fontSize: '12px', cursor: 'pointer' }}>
                      <Upload size={14} /> Upload Selfie
                      <input type="file" accept="image/*" onChange={handleSkinSelfieUpload} style={{ display: 'none' }} />
                    </label>
                    {skinSelfieImage && <span style={{ fontSize: '11px', color: '#10B981', fontWeight: 800, marginTop: '6px', display: 'block' }}>✓ Selfie Uploaded</span>}
                  </div>

                  {/* Full Body Photo Card */}
                  <div style={{ padding: '20px', borderRadius: '20px', background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.1)', textAlign: 'center' }}>
                    <Activity size={28} color="#EC4899" style={{ marginBottom: '10px' }} />
                    <h4 style={{ margin: '0 0 4px 0', fontSize: '15px' }}>2. Full Body Photo</h4>
                    <p style={{ margin: '0 0 14px 0', fontSize: '12px', color: '#9CA3AF' }}>Silhouette & proportions.</p>

                    <label className="morph-btn morph-btn-outline" style={{ width: '100%', justifyContent: 'center', fontSize: '12px', cursor: 'pointer' }}>
                      <Upload size={14} /> Upload Full Body
                      <input type="file" accept="image/*" onChange={handleFullBodyUpload} style={{ display: 'none' }} />
                    </label>
                    {fullBodyImage && <span style={{ fontSize: '11px', color: '#10B981', fontWeight: 800, marginTop: '6px', display: 'block' }}>✓ Full Body Uploaded</span>}
                  </div>

                </div>

                <div style={{ display: 'flex', gap: '12px' }}>
                  <button className="morph-btn morph-btn-outline" style={{ flex: 1, justifyContent: 'center' }} onClick={() => setSetupStep(3)}>
                    Back
                  </button>
                  <button 
                    className="morph-btn" 
                    style={{ flex: 2, justifyContent: 'center', padding: '18px', fontSize: '16px', background: 'linear-gradient(135deg, #6366F1, #EC4899)' }}
                    onClick={() => setAppState('main')}
                  >
                    Complete Setup & Open Dashboard Hub <Check size={20} />
                  </button>
                </div>
              </div>
            )}

          </div>
        </div>
      )}

      {/* ======================================================== */}
      {/* 3. MAIN AURA AI WORKSPACE ECOSYSTEM */}
      {/* ======================================================== */}
      {appState === 'main' && (
        <div style={{ display: 'flex', minHeight: '100vh' }}>
          
          {/* Sidebar Navigation */}
          <aside style={{ width: '290px', backgroundColor: '#12141C', borderRight: '1px solid rgba(255,255,255,0.1)', padding: '24px', display: 'flex', flexDirection: 'column' }}>
            
            <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '24px' }}>
              <div style={{ width: '40px', height: '40px', borderRadius: '12px', background: 'linear-gradient(135deg, #6366F1, #EC4899)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <Sparkles size={22} color="#FFF" />
              </div>
              <div>
                <h1 style={{ margin: 0, fontSize: '18px', fontWeight: 800, letterSpacing: '2px' }}>AURA AI</h1>
                <span style={{ fontSize: '10px', color: '#9CA3AF', letterSpacing: '1px' }}>PERSONAL STYLIST ECOSYSTEM</span>
              </div>
            </div>

            {/* Logged In User Profile Chip */}
            <div style={{ marginBottom: '24px', padding: '14px', borderRadius: '16px', background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.08)', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                <div style={{ width: '36px', height: '36px', borderRadius: '12px', background: '#6366F1', color: '#FFF', fontWeight: 800, display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '14px' }}>
                  {userName.charAt(0)}
                </div>
                <div>
                  <h4 style={{ margin: 0, fontSize: '14px', fontWeight: 700 }}>{userName}</h4>
                  <span style={{ fontSize: '11px', color: '#9CA3AF' }}>{userGender.toUpperCase()} · {city}</span>
                </div>
              </div>
              <button onClick={() => setAppState('auth')} title="Log Out" style={{ background: 'none', border: 'none', color: '#9CA3AF', cursor: 'pointer' }}>
                <LogOut size={16} />
              </button>
            </div>

            {/* GENDER TOGGLE */}
            <div style={{ marginBottom: '24px', padding: '14px', borderRadius: '16px', background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.08)' }}>
              <span style={{ fontSize: '11px', color: '#6366F1', fontWeight: 700, letterSpacing: '1px', display: 'block', marginBottom: '8px' }}>STYLING PROFILE GENDER</span>
              <div style={{ display: 'flex', gap: '4px', background: 'rgba(0,0,0,0.4)', padding: '4px', borderRadius: '12px' }}>
                {[
                  { id: 'female', label: '👩 Female' },
                  { id: 'male', label: '👨 Male' },
                  { id: 'unisex', label: '✨ Unisex' }
                ].map((g) => (
                  <button
                    key={g.id}
                    onClick={() => setUserGender(g.id as any)}
                    style={{
                      flex: 1, padding: '6px 2px', borderRadius: '8px', border: 'none', fontSize: '11px', fontWeight: 700, cursor: 'pointer',
                      backgroundColor: userGender === g.id ? '#6366F1' : 'transparent',
                      color: userGender === g.id ? '#FFF' : '#9CA3AF',
                      transition: 'all 0.2s ease'
                    }}
                  >
                    {g.label}
                  </button>
                ))}
              </div>
            </div>

            <nav style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
              <button
                onClick={() => { stopCamera(); setCurrentTab('dashboard'); }}
                style={{
                  display: 'flex', alignItems: 'center', gap: '14px', padding: '12px 16px', borderRadius: '14px', border: 'none',
                  backgroundColor: currentTab === 'dashboard' ? 'rgba(99, 102, 241, 0.2)' : 'transparent',
                  color: currentTab === 'dashboard' ? '#6366F1' : '#9CA3AF',
                  fontWeight: currentTab === 'dashboard' ? 700 : 500, fontSize: '14px', cursor: 'pointer', textAlign: 'left'
                }}
              >
                <Layers size={18} color={currentTab === 'dashboard' ? '#6366F1' : '#9CA3AF'} />
                Dashboard Hub
              </button>

              <button
                onClick={() => { stopCamera(); setCurrentTab('skin-scanner'); }}
                style={{
                  display: 'flex', alignItems: 'center', gap: '14px', padding: '12px 16px', borderRadius: '14px', border: 'none',
                  backgroundColor: currentTab === 'skin-scanner' ? 'rgba(99, 102, 241, 0.2)' : 'transparent',
                  color: currentTab === 'skin-scanner' ? '#6366F1' : '#9CA3AF',
                  fontWeight: currentTab === 'skin-scanner' ? 700 : 500, fontSize: '14px', cursor: 'pointer', textAlign: 'left'
                }}
              >
                <Flame size={18} color={currentTab === 'skin-scanner' ? '#6366F1' : '#9CA3AF'} />
                1. Upload Selfie → Skin Tone
              </button>

              <button
                onClick={() => { stopCamera(); setCurrentTab('body-scanner'); }}
                style={{
                  display: 'flex', alignItems: 'center', gap: '14px', padding: '12px 16px', borderRadius: '14px', border: 'none',
                  backgroundColor: currentTab === 'body-scanner' ? 'rgba(236, 72, 153, 0.2)' : 'transparent',
                  color: currentTab === 'body-scanner' ? '#EC4899' : '#9CA3AF',
                  fontWeight: currentTab === 'body-scanner' ? 700 : 500, fontSize: '14px', cursor: 'pointer', textAlign: 'left'
                }}
              >
                <Activity size={18} color={currentTab === 'body-scanner' ? '#EC4899' : '#9CA3AF'} />
                2. Upload Full Body → Outfits
              </button>

              <hr style={{ borderColor: 'rgba(255,255,255,0.08)', margin: '8px 0' }} />

              {[
                { id: 'ai-stylist', label: 'AI Stylist Chat', icon: MessageSquare },
                { id: 'wardrobe', label: 'Digital Closet', icon: Shirt },
                { id: 'occasions', label: 'Occasion Planner', icon: Calendar },
                { id: 'packing', label: 'Smart Packing', icon: Luggage },
                { id: 'shopping', label: 'Shopping Advisor', icon: ShoppingBag }
              ].map((item) => {
                const IconComp = item.icon;
                const active = currentTab === item.id;
                return (
                  <button
                    key={item.id}
                    onClick={() => { stopCamera(); setCurrentTab(item.id as any); }}
                    style={{
                      display: 'flex', alignItems: 'center', gap: '14px', padding: '10px 16px', borderRadius: '14px', border: 'none',
                      backgroundColor: active ? 'rgba(99, 102, 241, 0.15)' : 'transparent',
                      color: active ? '#6366F1' : '#9CA3AF',
                      fontWeight: active ? 600 : 500, fontSize: '14px', cursor: 'pointer', textAlign: 'left'
                    }}
                  >
                    <IconComp size={18} color={active ? '#6366F1' : '#9CA3AF'} />
                    {item.label}
                  </button>
                );
              })}
            </nav>
          </aside>

          {/* Main Workspace Workspace */}
          <main style={{ flex: 1, padding: '32px 40px', overflowY: 'auto' }}>
            
            {/* DASHBOARD HUB */}
            {currentTab === 'dashboard' && (
              <div style={{ maxWidth: '840px', margin: '0 auto' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '32px' }}>
                  <div>
                    <span style={{ fontSize: '11px', letterSpacing: '2px', color: '#9CA3AF', fontWeight: 700 }}>PERSONAL FASHION HUB ({userGender.toUpperCase()})</span>
                    <h2 style={{ margin: '4px 0 0 0', fontSize: '28px' }}>{userName}</h2>
                  </div>
                  <div style={{ display: 'flex', gap: '12px' }}>
                    <button className="morph-btn" onClick={() => setCurrentTab('ai-stylist')}>
                      <Sparkles size={16} /> Ask AI Stylist
                    </button>
                  </div>
                </div>

                {/* 1. COLOR RECOMMENDATION CARD ON DASHBOARD */}
                <div className="glass-card glowing" style={{ padding: '32px', marginBottom: '28px', borderRadius: '28px' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                    <span style={{ padding: '6px 14px', borderRadius: '20px', backgroundColor: 'rgba(99, 102, 241, 0.2)', color: '#6366F1', fontSize: '12px', fontWeight: 700, display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <Flame size={14} color="#6366F1" /> YOUR PERSONAL COLOR PALETTE
                    </span>
                    <span style={{ color: '#10B981', fontSize: '13px', fontWeight: 800, letterSpacing: '1px' }}>{skinResult.paletteName}</span>
                  </div>

                  <h3 style={{ fontSize: '24px', margin: '0 0 8px 0' }}>Detected Tone: {skinResult.detectedTone} ({skinResult.undertone})</h3>
                  <p style={{ color: '#9CA3AF', fontSize: '14px', margin: '0 0 20px 0', lineHeight: 1.5 }}>
                    {skinResult.reasoning}
                  </p>

                  <div style={{ display: 'flex', gap: '10px', marginBottom: '24px' }}>
                    {skinResult.powerColors.map((c: any) => (
                      <div key={c.hex} style={{ flex: 1, padding: '12px', borderRadius: '14px', backgroundColor: c.hex, textAlign: 'center', border: '1px solid rgba(255,255,255,0.2)' }}>
                        <span style={{ fontSize: '11px', fontWeight: 700, color: '#FFF', textShadow: '0 1px 3px rgba(0,0,0,0.8)' }}>{c.name}</span>
                      </div>
                    ))}
                  </div>

                  <button 
                    className="morph-btn morph-btn-outline" 
                    style={{ width: '100%', justifyContent: 'center' }}
                    onClick={() => {
                      stopCamera();
                      setCurrentTab('skin-scanner');
                      window.scrollTo({ top: 0, behavior: 'smooth' });
                    }}
                  >
                    View Full Color Analysis & Selfie Scanner <ArrowRight size={18} />
                  </button>
                </div>

                {/* 2. TAILORED OUTFIT RECOMMENDATION CARD WITH IMAGE BASED ON PROFILE SETUP GENDER */}
                <div className="glass-card glowing" style={{ padding: '32px', marginBottom: '32px', borderRadius: '28px', borderLeft: '4px solid #EC4899', overflow: 'hidden' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                    <span style={{ padding: '6px 14px', borderRadius: '20px', backgroundColor: 'rgba(236, 72, 153, 0.2)', color: '#EC4899', fontSize: '12px', fontWeight: 700, display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <Activity size={14} color="#EC4899" /> SILHOUETTE OUTFIT MATCH ({userGender.toUpperCase()})
                    </span>
                    <span style={{ color: '#10B981', fontSize: '13px', fontWeight: 800, letterSpacing: '1px' }}>{bodyResult.recommendedOutfits[0].suitability}</span>
                  </div>

                  <div style={{ width: '100%', height: '260px', borderRadius: '20px', overflow: 'hidden', marginBottom: '20px', position: 'relative' }}>
                    <img src={bodyResult.recommendedOutfits[0].imageUrl} alt="Recommended Outfit" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                    <div style={{ position: 'absolute', bottom: 0, left: 0, right: 0, padding: '16px 20px', background: 'linear-gradient(to top, rgba(9,10,15,0.95), transparent)' }}>
                      <h4 style={{ margin: 0, color: '#FFF', fontSize: '18px' }}>{bodyResult.recommendedOutfits[0].title}</h4>
                    </div>
                  </div>

                  <p style={{ color: '#9CA3AF', fontSize: '15px', margin: '0 0 20px 0', lineHeight: 1.6 }}>
                    {bodyResult.recommendedOutfits[0].description}
                  </p>

                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px', marginBottom: '24px' }}>
                    {bodyResult.recommendedOutfits[0].items.map((item: string, idx: number) => (
                      <div key={idx} style={{ padding: '10px 14px', borderRadius: '12px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.08)', fontSize: '13px', display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <CheckCircle size={14} color="#10B981" /> {item}
                      </div>
                    ))}
                  </div>

                  <button 
                    className="morph-btn morph-btn-outline" 
                    style={{ width: '100%', justifyContent: 'center' }}
                    onClick={() => {
                      stopCamera();
                      setCurrentTab('body-scanner');
                      window.scrollTo({ top: 0, behavior: 'smooth' });
                    }}
                  >
                    View Full Body & Outfit Analysis <ArrowRight size={18} />
                  </button>
                </div>

              </div>
            )}

            {/* SKIN TONE TAB */}
            {currentTab === 'skin-scanner' && (
              <div style={{ maxWidth: '720px', margin: '0 auto' }}>
                <span style={{ fontSize: '11px', letterSpacing: '2px', color: '#6366F1', fontWeight: 700 }}>STEP 1 OF 2</span>
                <h2 style={{ fontSize: '32px', margin: '4px 0 8px 0' }}>Upload Selfie for Skin Tone & Power Colors</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '28px', fontSize: '16px' }}>
                  Upload a close-up selfie or take a camera snapshot to analyze your facial skin tone level, undertone, and power color palette.
                </p>

                <div className="glass-card glowing" style={{ padding: '32px', textAlign: 'center', position: 'relative' }}>
                  
                  <div style={{ width: '100%', height: '360px', borderRadius: '24px', backgroundColor: '#000', overflow: 'hidden', position: 'relative', marginBottom: '24px', display: 'flex', alignItems: 'center', justifyContent: 'center', border: '1px solid rgba(255,255,255,0.15)' }}>
                    {skinSelfieImage ? (
                      <img src={skinSelfieImage} alt="Uploaded Selfie" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                    ) : (
                      <video ref={videoRef} playsInline muted style={{ width: '100%', height: '100%', objectFit: 'cover', display: cameraActive ? 'block' : 'none' }} />
                    )}

                    {!cameraActive && !skinSelfieImage && (
                      <div style={{ textAlign: 'center', padding: '24px' }}>
                        <User size={54} color="#6366F1" style={{ marginBottom: '12px' }} />
                        <h4 style={{ margin: '0 0 8px 0', fontSize: '18px' }}>Upload Your Close-Up Selfie</h4>
                        <p style={{ color: '#9CA3AF', margin: '0 0 20px 0', fontSize: '14px' }}>Ensure clear face lighting for accurate undertone colorimetry.</p>
                      </div>
                    )}
                  </div>

                  <div style={{ display: 'flex', gap: '12px', justifyContent: 'center', flexWrap: 'wrap' }}>
                    <label className="morph-btn" style={{ cursor: 'pointer' }}>
                      <Upload size={18} /> Upload Selfie File
                      <input type="file" accept="image/*" onChange={handleSkinSelfieUpload} style={{ display: 'none' }} />
                    </label>

                    {!cameraActive && (
                      <button className="morph-btn morph-btn-outline" onClick={startCamera}>
                        <Video size={16} /> Take Selfie via Camera
                      </button>
                    )}

                    {cameraActive && (
                      <button className="morph-btn" onClick={() => capturePhotoForTab('skin-scanner')}>
                        <Camera size={18} /> Capture Snapshot
                      </button>
                    )}
                  </div>

                  <div style={{ marginTop: '32px', textAlign: 'left' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
                      <h3 style={{ color: '#10B981', margin: 0, display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <CheckCircle size={22} /> Skin Tone Analysis Results ({userGender.toUpperCase()})
                      </h3>
                      <span style={{ padding: '6px 14px', borderRadius: '20px', backgroundColor: 'rgba(99,102,241,0.2)', color: '#6366F1', fontSize: '12px', fontWeight: 700 }}>
                        {skinResult.paletteName}
                      </span>
                    </div>

                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '14px', marginBottom: '24px' }}>
                      <div style={{ padding: '16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.08)' }}>
                        <span style={{ fontSize: '11px', color: '#9CA3AF', fontWeight: 700 }}>DETECTED SKIN TONE</span>
                        <p style={{ margin: '4px 0 0 0', fontWeight: 700, fontSize: '16px' }}>{skinResult.detectedTone}</p>
                      </div>
                      <div style={{ padding: '16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.08)' }}>
                        <span style={{ fontSize: '11px', color: '#9CA3AF', fontWeight: 700 }}>UNDERTONE</span>
                        <p style={{ margin: '4px 0 0 0', fontWeight: 700, fontSize: '16px' }}>{skinResult.undertone}</p>
                      </div>
                    </div>

                    <h4 style={{ fontSize: '16px', marginBottom: '12px' }}>Your Recommended Power Colors</h4>
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: '12px', marginBottom: '24px' }}>
                      {skinResult.powerColors.map((c: any) => (
                        <div key={c.hex} style={{ padding: '14px 10px', borderRadius: '16px', backgroundColor: c.hex, border: '1px solid rgba(255,255,255,0.2)', textAlign: 'center' }}>
                          <span style={{ fontSize: '12px', fontWeight: 700, color: '#FFF', textShadow: '0 1px 3px rgba(0,0,0,0.8)' }}>{c.name}</span>
                        </div>
                      ))}
                    </div>

                    <div style={{ display: 'flex', justifyContent: 'center' }}>
                      <button 
                        className="morph-btn" 
                        style={{ width: '100%', padding: '18px', fontSize: '17px', background: 'gradient(135deg, #EC4899, #6366F1)' }}
                        onClick={() => {
                          stopCamera();
                          setCurrentTab('body-scanner');
                          window.scrollTo({ top: 0, behavior: 'smooth' });
                        }}
                      >
                        Next: Proceed to Full-Body Scan for Outfits <ArrowRight size={20} />
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* FULL BODY TAB */}
            {currentTab === 'body-scanner' && (
              <div style={{ maxWidth: '760px', margin: '0 auto' }}>
                <span style={{ fontSize: '11px', letterSpacing: '2px', color: '#EC4899', fontWeight: 700 }}>STEP 2 OF 2 ({userGender.toUpperCase()})</span>
                <h2 style={{ fontSize: '32px', margin: '4px 0 8px 0' }}>Upload Full-Body Photo for Body Shape & Outfits</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '28px', fontSize: '16px' }}>
                  Upload a standing full-body photo to analyze your silhouette, shoulder-to-waist proportions, and receive visual outfit cards matched for {userGender}.
                </p>

                <div className="glass-card glowing" style={{ padding: '32px', textAlign: 'center', position: 'relative' }}>
                  
                  <div style={{ width: '100%', height: '380px', borderRadius: '24px', backgroundColor: '#000', overflow: 'hidden', position: 'relative', marginBottom: '24px', display: 'flex', alignItems: 'center', justifyContent: 'center', border: '1px solid rgba(255,255,255,0.15)' }}>
                    {fullBodyImage ? (
                      <img src={fullBodyImage} alt="Uploaded Full Body Photo" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                    ) : (
                      <video ref={videoRef} playsInline muted style={{ width: '100%', height: '100%', objectFit: 'cover', display: cameraActive ? 'block' : 'none' }} />
                    )}

                    {!cameraActive && !fullBodyImage && (
                      <div style={{ textAlign: 'center', padding: '24px' }}>
                        <Activity size={54} color="#EC4899" style={{ marginBottom: '12px' }} />
                        <h4 style={{ margin: '0 0 8px 0', fontSize: '18px' }}>Upload Your Standing Full-Body Photo</h4>
                        <p style={{ color: '#9CA3AF', margin: '0 0 20px 0', fontSize: '14px' }}>Ensure shoulders and trousers are visible for silhouette classification.</p>
                      </div>
                    )}
                  </div>

                  <div style={{ display: 'flex', gap: '12px', justifyContent: 'center', flexWrap: 'wrap' }}>
                    <label className="morph-btn" style={{ cursor: 'pointer' }}>
                      <Upload size={18} /> Upload Full Body Photo
                      <input type="file" accept="image/*" onChange={handleFullBodyUpload} style={{ display: 'none' }} />
                    </label>

                    {!cameraActive && (
                      <button className="morph-btn morph-btn-outline" onClick={startCamera}>
                        <Video size={16} /> Take Full Body Photo via Camera
                      </button>
                    )}

                    {cameraActive && (
                      <button className="morph-btn" onClick={() => capturePhotoForTab('body-scanner')}>
                        <Camera size={18} /> Capture Snapshot
                      </button>
                    )}
                  </div>

                  <div style={{ marginTop: '36px', textAlign: 'left' }}>
                    <h3 style={{ color: '#10B981', margin: '0 0 16px 0', display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <CheckCircle size={22} /> Detected Silhouette Metrics ({userGender.toUpperCase()})
                    </h3>

                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '12px', marginBottom: '32px' }}>
                      <div style={{ padding: '16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.08)' }}>
                        <span style={{ fontSize: '11px', color: '#9CA3AF', fontWeight: 700 }}>BODY TYPE</span>
                        <p style={{ margin: '4px 0 0 0', fontWeight: 700, fontSize: '15px' }}>{bodyResult.bodyShape}</p>
                      </div>
                      <div style={{ padding: '16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.08)' }}>
                        <span style={{ fontSize: '11px', color: '#9CA3AF', fontWeight: 700 }}>PROPORTIONS</span>
                        <p style={{ margin: '4px 0 0 0', fontWeight: 700, fontSize: '15px' }}>{bodyResult.shoulderRatio}</p>
                      </div>
                      <div style={{ padding: '16px', borderRadius: '16px', background: 'rgba(255,255,255,0.04)', border: '1px solid rgba(255,255,255,0.08)' }}>
                        <span style={{ fontSize: '11px', color: '#9CA3AF', fontWeight: 700 }}>HEIGHT</span>
                        <p style={{ margin: '4px 0 0 0', fontWeight: 700, fontSize: '15px' }}>{bodyResult.heightEstimate}</p>
                      </div>
                    </div>

                    <h4 style={{ fontSize: '20px', marginBottom: '20px' }}>Visual {userGender.toUpperCase()} Outfit Recommendations</h4>
                    
                    <div style={{ display: 'grid', gridTemplateColumns: '1fr', gap: '24px', marginBottom: '32px' }}>
                      {bodyResult.recommendedOutfits.map((outfit: any, idx: number) => (
                        <div key={idx} style={{ borderRadius: '24px', background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.1)', overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
                          <div style={{ width: '100%', height: '280px', position: 'relative', overflow: 'hidden' }}>
                            <img src={outfit.imageUrl} alt={outfit.title} style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                            <div style={{ position: 'absolute', top: '16px', right: '16px' }}>
                              <span style={{ padding: '6px 14px', borderRadius: '16px', background: 'rgba(16,185,129,0.9)', color: '#FFF', fontSize: '12px', fontWeight: 800 }}>
                                {outfit.suitability}
                              </span>
                            </div>
                          </div>

                          <div style={{ padding: '24px' }}>
                            <h5 style={{ margin: '0 0 8px 0', fontSize: '18px', fontWeight: 700 }}>{outfit.title}</h5>
                            <p style={{ margin: '0 0 16px 0', fontSize: '14px', color: '#9CA3AF', lineHeight: 1.6 }}>
                              {outfit.description}
                            </p>

                            <span style={{ fontSize: '11px', color: '#6366F1', fontWeight: 700, letterSpacing: '1px' }}>RECOMMENDED GARMENTS IN THIS LOOK</span>
                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px', marginTop: '8px' }}>
                              {outfit.items.map((item: string, i: number) => (
                                <div key={i} style={{ padding: '8px 12px', borderRadius: '12px', background: 'rgba(255,255,255,0.05)', fontSize: '13px', color: '#E5E7EB', display: 'flex', alignItems: 'center', gap: '8px' }}>
                                  <CheckCircle size={14} color="#10B981" /> {item}
                                </div>
                              ))}
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>

                    <div style={{ display: 'flex', justifyContent: 'center' }}>
                      <button 
                        className="morph-btn" 
                        style={{ width: '100%', padding: '18px', fontSize: '17px' }}
                        onClick={() => {
                          stopCamera();
                          setCurrentTab('dashboard');
                          window.scrollTo({ top: 0, behavior: 'smooth' });
                        }}
                      >
                        Complete Setup & Open Dashboard Hub <ArrowRight size={20} />
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* AI STYLIST TAB */}
            {currentTab === 'ai-stylist' && (
              <div style={{ maxWidth: '720px', margin: '0 auto', height: 'calc(100vh - 120px)', display: 'flex', flexDirection: 'column' }}>
                <h2 style={{ fontSize: '28px', marginBottom: '16px' }}>Aura AI Stylist Chat</h2>

                <div style={{ flex: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '16px', paddingRight: '8px' }}>
                  {messages.map((msg, i) => (
                    <div key={i} style={{ alignSelf: msg.isUser ? 'flex-end' : 'flex-start', maxWidth: '80%', padding: '16px 20px', borderRadius: '20px', background: msg.isUser ? 'linear-gradient(135deg, #6366F1, #EC4899)' : '#12141C', border: msg.isUser ? 'none' : '1px solid rgba(255,255,255,0.1)', color: '#FFF' }}>
                      {msg.text}
                    </div>
                  ))}
                </div>

                <div style={{ marginTop: '20px' }}>
                  <div style={{ display: 'flex', gap: '12px' }}>
                    <input
                      type="text"
                      value={chatInput}
                      onChange={(e) => setChatInput(e.target.value)}
                      onKeyDown={(e) => e.key === 'Enter' && handleSendMessage()}
                      placeholder="Ask about fits, dress codes, paired colors..."
                      style={{ flex: 1, padding: '14px 20px', borderRadius: '24px', background: '#12141C', border: '1px solid rgba(255,255,255,0.15)', color: '#FFF', fontSize: '15px' }}
                    />
                    <button className="morph-btn" onClick={() => handleSendMessage()} style={{ padding: '14px 20px' }}>
                      <Send size={18} />
                    </button>
                  </div>
                </div>
              </div>
            )}

            {/* OTHER TABS */}
            {currentTab === 'wardrobe' && (
              <div>
                <h2 style={{ fontSize: '32px', marginBottom: '8px' }}>Digital Closet</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '28px' }}>42 scanned items cataloged by category and fabric type.</p>
              </div>
            )}

            {currentTab === 'occasions' && (
              <div style={{ maxWidth: '640px', margin: '0 auto' }}>
                <h2 style={{ fontSize: '32px', marginBottom: '8px' }}>Occasion Planner</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '28px' }}>Contextual outfit combinations generated for specific events.</p>
              </div>
            )}

            {currentTab === 'packing' && (
              <div style={{ maxWidth: '640px', margin: '0 auto' }}>
                <h2 style={{ fontSize: '32px', marginBottom: '8px' }}>Smart Packing Assistant</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '28px' }}>Capsule trip checklist generated based on destination & days.</p>
              </div>
            )}

            {currentTab === 'shopping' && (
              <div style={{ maxWidth: '640px', margin: '0 auto' }}>
                <h2 style={{ fontSize: '32px', marginBottom: '8px' }}>Shopping Link Advisor</h2>
                <p style={{ color: '#9CA3AF', marginBottom: '28px' }}>Evaluates "Buy vs. Skip" advice based on your owned closet synergy.</p>
              </div>
            )}

          </main>
        </div>
      )}

    </div>
  );
}
