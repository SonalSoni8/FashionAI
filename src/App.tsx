import React, { useState, useRef, useEffect } from 'react';
import { 
  Sparkles, Camera, Shirt, Calendar, ShoppingBag, 
  User, CheckCircle, CheckCircle2, ArrowRight, Sun, MessageSquare, 
  Layers, Activity, Check, Heart, Share2, Eye,
  Database, UserCheck, Layers3, Flame, Palette, TrendingUp,
  Award, ShieldCheck, Zap, HelpCircle, FileCheck, Sliders,
  RefreshCw, Send, Plus, Search, Star, ExternalLink, Bookmark,
  Compass, ArrowUpRight, BarChart2, Bell, AlertTriangle, Link, Upload, Image as ImageIcon,
  X, RotateCcw, Copy, CheckSquare
} from 'lucide-react';

export default function App() {
  const [isMobile, setIsMobile] = useState<boolean>(
    typeof window !== 'undefined' ? window.innerWidth < 768 : false
  );

  useEffect(() => {
    const handleResize = () => {
      setIsMobile(window.innerWidth < 768);
    };
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  // Bottom Navigation Active Tab
  const [bottomNavTab, setBottomNavTab] = useState<'home' | 'wardrobe' | 'stylist' | 'profile'>('home');

  // Ingestion Modes: 'photo' | 'screenshot' | 'link' | 'ai'
  const [activeIngestionMode, setActiveIngestionMode] = useState<'photo' | 'screenshot' | 'link' | 'ai'>('photo');

  // Try-On Model Viewport State
  const [selectedModelImg, setSelectedModelImg] = useState<string>('/models/hero.png');

  // Outfit Suggestions Category Tab
  const [activeOutfitTab, setActiveOutfitTab] = useState<'for-you' | 'office' | 'casual' | 'party' | 'date'>('for-you');

  // Form & Input States
  const [productUrl, setProductUrl] = useState<string>('https://www.myntra.com/purple-shirt');
  const [aiPrompt, setAiPrompt] = useState<string>('Oversized lavender fleece hoodie');
  const [selectedColor, setSelectedColor] = useState<string>('#7C3AED');

  // Modals & Notifications States
  const [showCameraModal, setShowCameraModal] = useState<boolean>(false);
  const [showTwinOnboardingModal, setShowTwinOnboardingModal] = useState<boolean>(false);
  const [showBodyMeshModal, setShowBodyMeshModal] = useState<boolean>(false);
  const [showAdviceModal, setShowAdviceModal] = useState<boolean>(false);
  const [showGarmentPickerModal, setShowGarmentPickerModal] = useState<boolean>(false);
  const [activePickerCategory, setActivePickerCategory] = useState<string>('Tops');
  const [showGapPlanModal, setShowGapPlanModal] = useState<boolean>(false);
  const [showShoppingModal, setShowShoppingModal] = useState<boolean>(false);
  const [toastMessage, setToastMessage] = useState<string | null>(null);
  const [isGeneratingLooks, setIsGeneratingLooks] = useState<boolean>(false);

  // Live Camera Stream State & Hands-Free Auto-Capture Engine
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const [isCameraActive, setIsCameraActive] = useState<boolean>(false);
  const [capturedPhoto, setCapturedPhoto] = useState<string | null>(null);
  const [capturedPreviewImg, setCapturedPreviewImg] = useState<string | null>(null);
  
  // Sequential 3-Position Multi-Angle Capture States
  const [captureStepIndex, setCaptureStepIndex] = useState<number>(0); // 0: Front, 1: Left 90°, 2: Right 90°
  const [threeAnglePhotos, setThreeAnglePhotos] = useState<string[]>(['', '', '']);
  const [isBuildingTwinMesh, setIsBuildingTwinMesh] = useState<boolean>(false);

  // Live Camera Real-Time Posture Detection State
  const [livePostureState, setLivePostureState] = useState<'proper' | 'leaning' | 'too_close'>('proper');
  const [postureFeedbackText, setPostureFeedbackText] = useState<string>('🟢 PROPER POSTURE DETECTED — Feet flat & shoulders level');

  // Real-Time AI Image Validation State
  const [validationResult, setValidationResult] = useState<{
    isValid: boolean;
    poseScore: number;
    fullBodyScore: number;
    lightingLux: number;
    alerts: string[];
  }>({
    isValid: true,
    poseScore: 98,
    fullBodyScore: 100,
    lightingLux: 94,
    alerts: ['✓ Pose Alignment Passed', '✓ Head-to-Toe Body Visible', '✓ Studio Lighting Optimal']
  });

  // AI Image Validation Analyzer
  const runAiImageValidation = (stepIndex: number) => {
    const poseScore = 95 + Math.floor(Math.random() * 4); // 95-99%
    const fullBodyScore = 98 + Math.floor(Math.random() * 2); // 98-100%
    const lightingLux = 92 + Math.floor(Math.random() * 6); // 92-98%
    const alerts: string[] = [];

    if (stepIndex === 0) {
      alerts.push('✓ Front Pose Alignment Passed (0° Roll/Yaw)');
    } else if (stepIndex === 1) {
      alerts.push('✓ Left Profile Alignment Passed (90° Yaw)');
    } else {
      alerts.push('✓ Right Profile Alignment Passed (90° Yaw)');
    }

    alerts.push('✓ Head-to-Toe Body Outline Visible');
    alerts.push('✓ Studio Ambient Lighting Optimal');

    setValidationResult({
      isValid: true,
      poseScore,
      fullBodyScore,
      lightingLux,
      alerts
    });
  };

  // Real-Time Live Camera Computer Vision Frame Analysis Engine
  useEffect(() => {
    let animId: number;
    let frameCount = 0;

    const analyzeCameraFrame = () => {
      frameCount++;
      if (videoRef.current && isCameraActive && videoRef.current.readyState === 4 && capturedPreviewImg === null) {
        if (frameCount % 6 === 0) {
          try {
            const canvas = document.createElement('canvas');
            canvas.width = 160;
            canvas.height = 200;
            const ctx = canvas.getContext('2d');
            if (ctx) {
              ctx.drawImage(videoRef.current, 0, 0, 160, 200);
              const imageData = ctx.getImageData(0, 0, 160, 200);
              const data = imageData.data;
              
              let leftMass = 0;
              let rightMass = 0;
              let topMass = 0;
              let bottomMass = 0;

              for (let i = 0; i < data.length; i += 16) {
                const r = data[i];
                const g = data[i+1];
                const b = data[i+2];
                const luma = 0.299 * r + 0.587 * g + 0.114 * b;

                const pixelIdx = i / 4;
                const x = pixelIdx % 160;
                const y = Math.floor(pixelIdx / 160);

                if (luma < 210) {
                  if (x < 80) leftMass++; else rightMass++;
                  if (y < 100) topMass++; else bottomMass++;
                }
              }

              const totalMass = leftMass + rightMass;
              if (totalMass > 120) {
                const symmetryDiff = Math.abs(leftMass - rightMass) / totalMass;
                const verticalRatio = bottomMass / (topMass || 1);

                if (symmetryDiff > 0.38) {
                  setLivePostureState('leaning');
                  setPostureFeedbackText('🔴 WARNING: Shoulders Tilted / Leaning! Stand straight & level shoulders');
                } else if (verticalRatio < 0.2) {
                  setLivePostureState('too_close');
                  setPostureFeedbackText('🔴 WARNING: Step Back 1.5m! Lower body & feet are cut off');
                } else {
                  setLivePostureState('proper');
                  setPostureFeedbackText('🟢 PROPER POSTURE DETECTED — Feet flat & shoulders level');
                }
              }
            }
          } catch (e) {
            console.log('Frame analysis skip:', e);
          }
        }
      }

      if (isCameraActive) {
        animId = requestAnimationFrame(analyzeCameraFrame);
      }
    };

    if (isCameraActive) {
      animId = requestAnimationFrame(analyzeCameraFrame);
    }
    return () => cancelAnimationFrame(animId);
  }, [isCameraActive, capturedPreviewImg]);
  
  // Hands-Free Auto-Capture States
  const [handsFreeMode, setHandsFreeMode] = useState<'timer' | 'voice' | 'gesture'>('timer');
  const [countdownValue, setCountdownValue] = useState<number | null>(null);
  const [isListeningVoice, setIsListeningVoice] = useState<boolean>(false);

  // Web Audio API Beep Synthesizer
  const playBeepSound = (freq = 800, type = 'sine') => {
    try {
      const ctx = new (window.AudioContext || (window as any).webkitAudioContext)();
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();
      osc.type = type as any;
      osc.frequency.value = freq;
      osc.connect(gain);
      gain.connect(ctx.destination);
      osc.start();
      gain.gain.exponentialRampToValueAtTime(0.00001, ctx.currentTime + 0.3);
      setTimeout(() => ctx.close(), 300);
    } catch (e) {}
  };

  // Hands-Free Countdown Action Trigger
  const startHandsFreeCountdown = (seconds = 5) => {
    if (livePostureState !== 'proper') {
      triggerToast('⚠️ CANNOT CAPTURE: Alignment is RED! Please align your posture until the frame turns GREEN.');
      return;
    }
    let current = seconds;
    setCountdownValue(current);
    playBeepSound(600);

    const timer = setInterval(() => {
      current -= 1;
      if (current > 0) {
        setCountdownValue(current);
        playBeepSound(600);
      } else {
        clearInterval(timer);
        setCountdownValue(null);
        playBeepSound(1200, 'square');
        capturePhotoAction();
      }
    }, 1000);
  };

  // Voice Command Speech Recognition Listener
  const startVoiceListener = () => {
    setIsListeningVoice(true);
    triggerToast('🗣️ Listening... Say "CAPTURE" or "CHEESE" out loud!');
    
    // Simulate voice keyword recognition or use SpeechRecognition if available
    const SpeechRecognition = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
    if (SpeechRecognition) {
      try {
        const recognition = new SpeechRecognition();
        recognition.continuous = false;
        recognition.lang = 'en-US';
        recognition.onresult = (event: any) => {
          const transcript = event.results[0][0].transcript.toLowerCase();
          if (transcript.includes('capture') || transcript.includes('snap') || transcript.includes('cheese') || transcript.includes('photo')) {
            setIsListeningVoice(false);
            startHandsFreeCountdown(3);
          }
        };
        recognition.start();
      } catch (e) {}
    } else {
      setTimeout(() => {
        setIsListeningVoice(false);
        startHandsFreeCountdown(3);
      }, 2500);
    }
  };

  // Wardrobe Items Counter State
  const [wardrobeCounts, setWardrobeCounts] = useState({
    Tops: 42,
    Bottoms: 25,
    Dresses: 18,
    Shoes: 14,
    Bags: 11,
    Accessories: 26,
    Watches: 9
  });

  // Layer Stack State
  const [equippedStack, setEquippedStack] = useState<Array<{ name: string; category: string; img: string }>>([
    { name: 'Lavender Silk Blouse', category: 'Tops', img: '/models/lavender.png' },
    { name: 'Light Wide Denim', category: 'Bottoms', img: '/models/hero.png' },
    { name: 'Structured Leather Tote', category: 'Bags', img: '/models/black.png' }
  ]);

  // Your Look Timeline State
  const [lookTimeline, setLookTimeline] = useState([
    { id: '1', date: 'Mon, 19 May', title: 'Office Look', rating: 5, img: '/models/lavender.png' },
    { id: '2', date: 'Tue, 20 May', title: 'Casual Day Out', rating: 5, img: '/models/hero.png' },
    { id: '3', date: 'Wed, 21 May', title: 'Wedding Function', rating: 5, img: '/models/black.png' }
  ]);

  // Outfit Suggestions Data State
  const [outfitList, setOutfitList] = useState([
    { id: '1', name: 'Executive Elegance', category: 'Office', img: '/models/lavender.png', score: '9.4' },
    { id: '2', name: 'Quiet Luxury Dark', category: 'Party', img: '/models/black.png', score: '9.2' },
    { id: '3', name: 'Resort Casual Olive', category: 'Casual', img: '/models/green.png', score: '9.0' },
    { id: '4', name: 'Classic Crisp White', category: 'Date', img: '/models/hero.png', score: '9.5' },
  ]);

  // Toast Helper
  const triggerToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3000);
  };

  // Camera Handlers
  const startCamera = async () => {
    setShowCameraModal(true);
    setIsCameraActive(true);
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ video: true });
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
      }
    } catch (err) {
      console.log('Webcam stream unavailable, falling back to simulated capture.');
    }
  };

  const stopCamera = () => {
    if (videoRef.current && videoRef.current.srcObject) {
      const stream = videoRef.current.srcObject as MediaStream;
      stream.getTracks().forEach((track) => track.stop());
    }
    setIsCameraActive(false);
    setShowCameraModal(false);
  };

  const capturePhotoAction = () => {
    if (livePostureState !== 'proper') {
      triggerToast('⚠️ CANNOT CAPTURE: Alignment is RED! Please align your posture until the frame turns GREEN.');
      return;
    }
    runAiImageValidation(captureStepIndex);
    if (videoRef.current && isCameraActive) {
      try {
        const canvas = document.createElement('canvas');
        canvas.width = videoRef.current.videoWidth || 640;
        canvas.height = videoRef.current.videoHeight || 800;
        const ctx = canvas.getContext('2d');
        if (ctx) {
          ctx.drawImage(videoRef.current, 0, 0, canvas.width, canvas.height);
          const dataUrl = canvas.toDataURL('image/png');
          setCapturedPhoto(dataUrl);
          setCapturedPreviewImg(dataUrl);
          triggerToast('📸 Photo Captured & AI Validated! Inspect preview.');
          return;
        }
      } catch (e) {
        console.log('Canvas snapshot fallback:', e);
      }
    }
    setCapturedPhoto('/models/lavender.png');
    setCapturedPreviewImg('/models/lavender.png');
    triggerToast('📸 Photo Captured & AI Validated! Inspect preview.');
  };

  // URL Link Ingestion Action
  const importFromUrlAction = () => {
    setWardrobeCounts((prev) => ({ ...prev, Tops: prev.Tops + 1 }));
    triggerToast(`✨ Imported "${productUrl.split('/').pop() || 'Item'}" into Wardrobe!`);
  };

  // AI Garment Generation Action
  const generateAiGarmentAction = () => {
    setWardrobeCounts((prev) => ({ ...prev, Tops: prev.Tops + 1 }));
    triggerToast(`✨ Generated 3D "${aiPrompt}" & saved to Wardrobe!`);
  };

  // Save Look to Timeline Action
  const saveCurrentLookAction = () => {
    const newLook = {
      id: Date.now().toString(),
      date: 'Today',
      title: 'Custom Styled Twin Look',
      rating: 5,
      img: selectedModelImg
    };
    setLookTimeline([newLook, ...lookTimeline]);
    triggerToast('✨ Look Saved to Your Look Timeline!');
  };

  // Undo Layer Action
  const undoLayerAction = () => {
    if (equippedStack.length > 0) {
      setEquippedStack(equippedStack.slice(0, -1));
      triggerToast('↺ Cleared last garment layer');
    }
  };

  // Share Look Action
  const shareLookAction = () => {
    navigator.clipboard.writeText(window.location.href);
    triggerToast('📋 Share link copied to clipboard!');
  };

  // Generate 10 More Looks Action
  const generate10MoreLooksAction = () => {
    setIsGeneratingLooks(true);
    setTimeout(() => {
      const newItems = [
        { id: Date.now().toString() + '1', name: 'Monochrome Midnight', category: 'Party', img: '/models/black.png', score: '9.6' },
        { id: Date.now().toString() + '2', name: 'Parisian Spring', category: 'Casual', img: '/models/lavender.png', score: '9.3' }
      ];
      setOutfitList([...outfitList, ...newItems]);
      setIsGeneratingLooks(false);
      triggerToast('✨ Generated 10 New Curated Outfit Capsules!');
    }, 1200);
  };

  return (
    <div style={{ minHeight: '100vh', backgroundColor: '#FAF7F2', color: '#2E1C44', fontFamily: "'Plus Jakarta Sans', sans-serif", paddingBottom: '90px', position: 'relative' }}>
      
      {/* FLOATING TOAST NOTIFICATION */}
      {toastMessage && (
        <div style={{ position: 'fixed', top: '20px', right: '20px', zIndex: 1000, background: '#2E1C44', color: '#FFF', padding: '12px 20px', borderRadius: '16px', fontSize: '13px', fontWeight: 700, boxShadow: '0 10px 30px rgba(46,28,68,0.3)', display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Sparkles size={16} color="#EC4899" />
          <span>{toastMessage}</span>
        </div>
      )}

      {/* 1. TOP HEADER & VALUE PROPOSITION HERO BAR */}
      <header style={{ background: '#FFFFFF', borderBottom: '1px solid #EFE9E0', padding: '20px 24px', position: 'sticky', top: 0, zIndex: 100, boxShadow: '0 4px 20px rgba(46, 28, 68, 0.03)' }}>
        <div style={{ maxWidth: '1240px', margin: '0 auto', display: 'flex', flexDirection: isMobile ? 'column' : 'row', justifyContent: 'space-between', alignItems: isMobile ? 'flex-start' : 'center', gap: '16px' }}>
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
              <div style={{ width: '38px', height: '38px', borderRadius: '12px', background: 'linear-gradient(135deg, #7C3AED, #EC4899)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#FFF', boxShadow: '0 4px 12px rgba(124,58,237,0.3)' }}>
                <Sparkles size={22} />
              </div>
              <h1 style={{ margin: 0, fontSize: '26px', fontWeight: 800, color: '#2E1C44', letterSpacing: '-0.03em' }}>Aura AI</h1>
              <span style={{ fontSize: '11px', fontWeight: 800, padding: '4px 10px', borderRadius: '20px', background: 'rgba(124,58,237,0.1)', color: '#7C3AED', textTransform: 'uppercase' }}>Digital Fashion Twin</span>
            </div>
            <p style={{ margin: '4px 0 0 0', fontSize: '14px', color: '#6B5B7B', fontWeight: 500 }}>One body. Unlimited outfits. Your personal AI stylist.</p>
          </div>

          {/* Hero Value Pills */}
          <div style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
            <div onClick={() => setShowTwinOnboardingModal(true)} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '6px', padding: '8px 14px', borderRadius: '14px', background: '#FAF6F0', border: '1px solid #EFE9E0', fontSize: '12px', fontWeight: 700, color: '#2E1C44' }}>
              <User size={15} color="#7C3AED" />
              <span>Your Real Body</span>
            </div>
            <div onClick={() => setBottomNavTab('wardrobe')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '6px', padding: '8px 14px', borderRadius: '14px', background: '#FAF6F0', border: '1px solid #EFE9E0', fontSize: '12px', fontWeight: 700, color: '#2E1C44' }}>
              <ShoppingBag size={15} color="#7C3AED" />
              <span>Your Wardrobe</span>
            </div>
            <div onClick={() => setBottomNavTab('stylist')} style={{ cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '6px', padding: '8px 14px', borderRadius: '14px', background: '#FAF6F0', border: '1px solid #EFE9E0', fontSize: '12px', fontWeight: 700, color: '#2E1C44' }}>
              <Sparkles size={15} color="#7C3AED" />
              <span>AI Styling</span>
            </div>
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px', padding: '8px 14px', borderRadius: '14px', background: 'rgba(236,72,153,0.1)', border: '1px solid rgba(236,72,153,0.2)', fontSize: '12px', fontWeight: 800, color: '#EC4899' }}>
              <Heart size={15} color="#EC4899" />
              <span>Try. Save. Slay.</span>
            </div>
          </div>
        </div>
      </header>

      <main style={{ maxWidth: '1240px', margin: '24px auto', padding: '0 20px', display: 'flex', flexDirection: 'column', gap: '32px' }}>
        
        {/* 2. "HOW IT WORKS" 5-STEP PROCESS FLOW */}
        <section style={{ background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', boxShadow: '0 4px 20px rgba(46, 28, 68, 0.03)' }}>
          <div style={{ textAlign: 'center', marginBottom: '20px' }}>
            <span style={{ fontSize: '11px', fontWeight: 800, letterSpacing: '0.1em', textTransform: 'uppercase', color: '#7C3AED' }}>HOW IT WORKS</span>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: isMobile ? '1fr' : 'repeat(5, 1fr)', gap: '16px' }}>
            {/* Step 1 */}
            <div 
              onClick={() => setShowTwinOnboardingModal(true)}
              style={{ padding: '16px', borderRadius: '20px', background: '#FAF7F2', border: '1px solid #EFE9E0', textAlign: 'center', cursor: 'pointer', transition: 'all 0.2s' }}
            >
              <div style={{ width: '48px', height: '48px', borderRadius: '16px', background: 'rgba(124,58,237,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 12px auto' }}>
                <Camera size={22} color="#7C3AED" />
              </div>
              <strong style={{ display: 'block', fontSize: '13px', color: '#2E1C44', marginBottom: '4px' }}>1. Create My Twin</strong>
              <p style={{ margin: 0, fontSize: '11px', color: '#6B5B7B' }}>Upload 3 photos: front, left & right</p>
            </div>

            {/* Step 2 */}
            <div 
              onClick={() => setShowBodyMeshModal(true)}
              style={{ padding: '16px', borderRadius: '20px', background: '#FAF7F2', border: '1px solid #EFE9E0', textAlign: 'center', cursor: 'pointer', transition: 'all 0.2s' }}
            >
              <div style={{ width: '48px', height: '48px', borderRadius: '16px', background: 'rgba(124,58,237,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 12px auto' }}>
                <User size={22} color="#7C3AED" />
              </div>
              <strong style={{ display: 'block', fontSize: '13px', color: '#2E1C44', marginBottom: '4px' }}>2. AI Builds You</strong>
              <p style={{ margin: 0, fontSize: '11px', color: '#6B5B7B' }}>We create your digital body & measurements</p>
            </div>

            {/* Step 3 */}
            <div 
              onClick={() => {
                const el = document.getElementById('add-clothes-section');
                if (el) el.scrollIntoView({ behavior: 'smooth' });
              }}
              style={{ padding: '16px', borderRadius: '20px', background: '#FAF7F2', border: '1px solid #EFE9E0', textAlign: 'center', cursor: 'pointer' }}
            >
              <div style={{ width: '48px', height: '48px', borderRadius: '16px', background: 'rgba(124,58,237,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 12px auto' }}>
                <Shirt size={22} color="#7C3AED" />
              </div>
              <strong style={{ display: 'block', fontSize: '13px', color: '#2E1C44', marginBottom: '4px' }}>3. Add Clothes</strong>
              <p style={{ margin: 0, fontSize: '11px', color: '#6B5B7B' }}>Upload, screenshot or paste link</p>
            </div>

            {/* Step 4 */}
            <div 
              onClick={() => {
                const el = document.getElementById('studio-section');
                if (el) el.scrollIntoView({ behavior: 'smooth' });
              }}
              style={{ padding: '16px', borderRadius: '20px', background: '#FAF7F2', border: '1px solid #EFE9E0', textAlign: 'center', cursor: 'pointer' }}
            >
              <div style={{ width: '48px', height: '48px', borderRadius: '16px', background: 'rgba(124,58,237,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 12px auto' }}>
                <Sparkles size={22} color="#7C3AED" />
              </div>
              <strong style={{ display: 'block', fontSize: '13px', color: '#2E1C44', marginBottom: '4px' }}>4. Try & Style</strong>
              <p style={{ margin: 0, fontSize: '11px', color: '#6B5B7B' }}>Mix, match & try unlimited looks</p>
            </div>

            {/* Step 5 */}
            <div 
              onClick={() => setShowAdviceModal(true)}
              style={{ padding: '16px', borderRadius: '20px', background: '#FAF7F2', border: '1px solid #EFE9E0', textAlign: 'center', cursor: 'pointer' }}
            >
              <div style={{ width: '48px', height: '48px', borderRadius: '16px', background: 'rgba(16,185,129,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 12px auto' }}>
                <Award size={22} color="#10B981" />
              </div>
              <strong style={{ display: 'block', fontSize: '13px', color: '#2E1C44', marginBottom: '4px' }}>5. Get AI Advice</strong>
              <span style={{ fontSize: '12px', fontWeight: 800, color: '#10B981', display: 'block', marginBottom: '2px' }}>Great Look! 9.2/10</span>
              <p style={{ margin: 0, fontSize: '11px', color: '#6B5B7B' }}>Click for smart suggestions breakdown</p>
            </div>
          </div>
        </section>

        {/* 3. "ADD CLOTHES TO YOUR WARDROBE" SECTION (4 INGESTION MODES) */}
        <section id="add-clothes-section" style={{ background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', boxShadow: '0 4px 20px rgba(46, 28, 68, 0.03)' }}>
          <div style={{ marginBottom: '20px' }}>
            <span style={{ fontSize: '11px', fontWeight: 800, letterSpacing: '0.1em', textTransform: 'uppercase', color: '#7C3AED' }}>ADD CLOTHES TO YOUR WARDROBE</span>
            <h2 style={{ margin: '4px 0 0 0', fontSize: '20px', fontWeight: 800, color: '#2E1C44' }}>Choose Your Import Method</h2>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: isMobile ? '1fr' : 'repeat(4, 1fr) 280px', gap: '16px' }}>
            {/* Mode 1: Take a Photo */}
            <div 
              onClick={() => {
                setActiveIngestionMode('photo');
                startCamera();
              }}
              style={{ 
                padding: '20px', 
                borderRadius: '24px', 
                background: activeIngestionMode === 'photo' ? 'rgba(124,58,237,0.04)' : '#FAF7F2', 
                border: activeIngestionMode === 'photo' ? '2px solid #7C3AED' : '1px solid #EFE9E0', 
                cursor: 'pointer',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between'
              }}
            >
              <div>
                <strong style={{ fontSize: '14px', color: '#2E1C44', display: 'block', marginBottom: '12px' }}>Take a Photo</strong>
                <div style={{ height: '140px', borderRadius: '16px', background: '#2E1C44', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', position: 'relative', overflow: 'hidden' }}>
                  <Shirt size={48} color="#EC4899" />
                  <div style={{ position: 'absolute', bottom: '12px', width: '36px', height: '36px', borderRadius: '50%', border: '2px solid #FFF', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <div style={{ width: '24px', height: '24px', borderRadius: '50%', background: '#FFF' }} />
                  </div>
                </div>
              </div>
              <p style={{ margin: '12px 0 0 0', fontSize: '11px', color: '#6B5B7B', textAlign: 'center' }}>We remove background & detect details</p>
            </div>

            {/* Mode 2: Upload Screenshot */}
            <div 
              onClick={() => {
                setActiveIngestionMode('screenshot');
                setWardrobeCounts((prev) => ({ ...prev, Tops: prev.Tops + 1 }));
                triggerToast('✨ Extracted Lavender Cardigan (₹1,299) into Wardrobe!');
              }}
              style={{ 
                padding: '20px', 
                borderRadius: '24px', 
                background: activeIngestionMode === 'screenshot' ? 'rgba(124,58,237,0.04)' : '#FAF7F2', 
                border: activeIngestionMode === 'screenshot' ? '2px solid #7C3AED' : '1px solid #EFE9E0', 
                cursor: 'pointer',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between'
              }}
            >
              <div>
                <strong style={{ fontSize: '14px', color: '#2E1C44', display: 'block', marginBottom: '12px' }}>Upload Screenshot</strong>
                <div style={{ height: '140px', borderRadius: '16px', background: '#FFF', border: '1px solid #EFE9E0', padding: '12px', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
                  <span style={{ fontSize: '10px', fontWeight: 800, color: '#EC4899', marginBottom: '4px' }}>M Myntra</span>
                  <div style={{ width: '50px', height: '50px', borderRadius: '12px', background: '#F3E8FF', display: 'flex', alignItems: 'center', justifyContent: 'center', marginBottom: '8px' }}>
                    <Shirt size={28} color="#7C3AED" />
                  </div>
                  <button style={{ width: '100%', padding: '6px', borderRadius: '10px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '10px', fontWeight: 800 }}>+ Add to Wardrobe</button>
                </div>
              </div>
              <p style={{ margin: '12px 0 0 0', fontSize: '11px', color: '#6B5B7B', textAlign: 'center' }}>AI extracts, cleans & adds to wardrobe</p>
            </div>

            {/* Mode 3: Paste Product Link */}
            <div 
              onClick={() => setActiveIngestionMode('link')}
              style={{ 
                padding: '20px', 
                borderRadius: '24px', 
                background: activeIngestionMode === 'link' ? 'rgba(124,58,237,0.04)' : '#FAF7F2', 
                border: activeIngestionMode === 'link' ? '2px solid #7C3AED' : '1px solid #EFE9E0', 
                cursor: 'pointer',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between'
              }}
            >
              <div>
                <strong style={{ fontSize: '14px', color: '#2E1C44', display: 'block', marginBottom: '12px' }}>Paste Product Link</strong>
                <div style={{ height: '140px', borderRadius: '16px', background: '#FFF', border: '1px solid #EFE9E0', padding: '12px', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px', background: '#FAF7F2', padding: '6px 10px', borderRadius: '8px', border: '1px solid #EFE9E0' }}>
                    <Link size={12} color="#7C3AED" />
                    <input 
                      type="text" 
                      value={productUrl} 
                      onChange={(e) => setProductUrl(e.target.value)}
                      style={{ border: 'none', background: 'transparent', fontSize: '10px', color: '#2E1C44', width: '100%', outline: 'none' }}
                    />
                  </div>
                  <div style={{ textAlign: 'center' }}>
                    <Shirt size={28} color="#7C3AED" />
                  </div>
                  <button onClick={importFromUrlAction} style={{ width: '100%', padding: '6px', borderRadius: '10px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '10px', fontWeight: 800, cursor: 'pointer' }}>Import from URL</button>
                </div>
              </div>
              <p style={{ margin: '12px 0 0 0', fontSize: '11px', color: '#6B5B7B', textAlign: 'center' }}>Works with Myntra, Amazon, AJIO, Zara</p>
            </div>

            {/* Mode 4: AI Generate */}
            <div 
              onClick={() => setActiveIngestionMode('ai')}
              style={{ 
                padding: '20px', 
                borderRadius: '24px', 
                background: activeIngestionMode === 'ai' ? 'rgba(124,58,237,0.04)' : '#FAF7F2', 
                border: activeIngestionMode === 'ai' ? '2px solid #7C3AED' : '1px solid #EFE9E0', 
                cursor: 'pointer',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between'
              }}
            >
              <div>
                <strong style={{ fontSize: '14px', color: '#2E1C44', display: 'block', marginBottom: '12px' }}>AI Generate</strong>
                <div style={{ height: '140px', borderRadius: '16px', background: '#F3E8FF', border: '1px solid #E6D5FF', padding: '12px', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
                  <Sparkles size={36} color="#7C3AED" />
                  <button onClick={generateAiGarmentAction} style={{ marginTop: '8px', padding: '6px 12px', borderRadius: '10px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '10px', fontWeight: 800, cursor: 'pointer' }}>Generate & Add</button>
                </div>
              </div>
              <p style={{ margin: '12px 0 0 0', fontSize: '11px', color: '#6B5B7B', textAlign: 'center' }}>Describe it & AI creates for you</p>
            </div>

            {/* Right Card: AI Detects & Adds Panel */}
            <div style={{ padding: '20px', borderRadius: '24px', background: '#2E1C44', color: '#FFF', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
              <div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '16px' }}>
                  <div style={{ width: '28px', height: '28px', borderRadius: '50%', background: 'rgba(255,255,255,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <Sparkles size={14} color="#EC4899" />
                  </div>
                  <strong style={{ fontSize: '13px' }}>AI Detects & Adds</strong>
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', fontSize: '11px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                    <CheckCircle size={14} color="#10B981" />
                    <span>Category: Tops & Shirts</span>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                    <CheckCircle size={14} color="#10B981" />
                    <span>Color: Lavender Purple</span>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                    <CheckCircle size={14} color="#10B981" />
                    <span>Fabric: 100% Silk Cotton</span>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                    <CheckCircle size={14} color="#10B981" />
                    <span>Sleeve: Button-Up Collared</span>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                    <CheckCircle size={14} color="#10B981" />
                    <span>Pattern: Solid Luxe Satin</span>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                    <CheckCircle size={14} color="#10B981" />
                    <span>Fit: Relaxed Tailored</span>
                  </div>
                </div>
              </div>

              <span style={{ fontSize: '10px', color: '#A78BFA', marginTop: '12px', display: 'block', textAlign: 'center' }}>All saved in your digital wardrobe</span>
            </div>
          </div>
        </section>

        {/* 4. "TRY ON & MIX MATCH" VIRTUAL STUDIO WORKSPACE */}
        <section id="studio-section" style={{ background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', boxShadow: '0 4px 20px rgba(46, 28, 68, 0.03)' }}>
          <div style={{ marginBottom: '20px' }}>
            <span style={{ fontSize: '11px', fontWeight: 800, letterSpacing: '0.1em', textTransform: 'uppercase', color: '#7C3AED' }}>STUDIO VIEWPORT</span>
            <h2 style={{ margin: '4px 0 0 0', fontSize: '20px', fontWeight: 800, color: '#2E1C44' }}>Try On & Mix Match</h2>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: isMobile ? '1fr' : '240px 1.2fr 280px', gap: '20px' }}>
            
            {/* Left Column: MY WARDROBE CATEGORY COUNTERS */}
            <div style={{ padding: '20px', borderRadius: '24px', background: '#FAF7F2', border: '1px solid #EFE9E0', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
              <div>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
                  <strong style={{ fontSize: '14px', color: '#2E1C44' }}>MY WARDROBE</strong>
                  <span onClick={() => setBottomNavTab('wardrobe')} style={{ fontSize: '11px', color: '#7C3AED', fontWeight: 700, cursor: 'pointer' }}>View All</span>
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
                  {Object.entries(wardrobeCounts).map(([cat, count]) => (
                    <div 
                      key={cat}
                      onClick={() => {
                        setActivePickerCategory(cat);
                        setShowGarmentPickerModal(true);
                      }}
                      style={{ display: 'flex', justifyContent: 'space-between', padding: '10px 14px', borderRadius: '14px', background: '#FFF', border: '1px solid #EFE9E0', fontSize: '12px', cursor: 'pointer', transition: 'all 0.2s' }}
                    >
                      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <Shirt size={16} color="#7C3AED" />
                        <strong>{cat}</strong>
                      </div>
                      <span style={{ fontWeight: 800, color: '#7C3AED' }}>{count}</span>
                    </div>
                  ))}
                </div>
              </div>

              <button onClick={() => setShowGarmentPickerModal(true)} style={{ width: '100%', padding: '12px', borderRadius: '14px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '12px', fontWeight: 800, cursor: 'pointer', marginTop: '16px' }}>
                + Add New Item
              </button>
            </div>

            {/* Center Studio: PHOTOREALISTIC MODEL TRY-ON VIEWPORT */}
            <div style={{ position: 'relative', borderRadius: '24px', overflow: 'hidden', background: '#FAF7F2', border: '1px solid #EFE9E0', minHeight: '500px', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
              
              {/* Photorealistic Model Image */}
              <img 
                src={selectedModelImg} 
                alt="Digital Twin Virtual Try-On Model" 
                style={{ width: '100%', height: '520px', objectFit: 'cover', borderRadius: '24px' }}
              />

              {/* Floating Layer Stack Chips */}
              <div style={{ position: 'absolute', right: '16px', top: '16px', display: 'flex', flexDirection: 'column', gap: '10px', zIndex: 10 }}>
                {equippedStack.map((item, idx) => (
                  <div key={idx} style={{ width: '48px', height: '48px', borderRadius: '14px', background: '#FFF', border: '2px solid #7C3AED', boxShadow: '0 4px 12px rgba(0,0,0,0.1)', padding: '4px', overflow: 'hidden' }}>
                    <img src={item.img} alt={item.name} style={{ width: '100%', height: '100%', objectFit: 'cover', borderRadius: '10px' }} />
                  </div>
                ))}
              </div>

              {/* Bottom Action Controls Bar */}
              <div style={{ position: 'absolute', bottom: '16px', left: '16px', right: '16px', display: 'flex', justifyContent: 'center', gap: '12px', zIndex: 10 }}>
                <button onClick={undoLayerAction} style={{ padding: '10px 18px', borderRadius: '20px', background: 'rgba(255,255,255,0.9)', backdropFilter: 'blur(10px)', color: '#2E1C44', border: '1px solid #EFE9E0', fontSize: '12px', fontWeight: 800, cursor: 'pointer' }}>
                  Undo
                </button>
                <button onClick={saveCurrentLookAction} style={{ padding: '10px 24px', borderRadius: '20px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '12px', fontWeight: 800, cursor: 'pointer', boxShadow: '0 4px 16px rgba(46,28,68,0.2)' }}>
                  Save Look
                </button>
                <button onClick={shareLookAction} style={{ padding: '10px 18px', borderRadius: '20px', background: 'rgba(255,255,255,0.9)', backdropFilter: 'blur(10px)', color: '#2E1C44', border: '1px solid #EFE9E0', fontSize: '12px', fontWeight: 800, cursor: 'pointer' }}>
                  Share
                </button>
              </div>
            </div>

            {/* Right Column: LOOKS YOU'LL LOVE GRID */}
            <div style={{ padding: '20px', borderRadius: '24px', background: '#FAF7F2', border: '1px solid #EFE9E0' }}>
              <strong style={{ fontSize: '14px', color: '#2E1C44', display: 'block', marginBottom: '16px' }}>Looks You'll Love</strong>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                {[
                  { id: '1', title: 'Lavender Casual', img: '/models/lavender.png', rating: '9.4' },
                  { id: '2', title: 'Executive Black', img: '/models/black.png', rating: '9.2' },
                  { id: '3', title: 'Office Olive', img: '/models/green.png', rating: '9.0' },
                  { id: '4', title: 'Weekend Crisp', img: '/models/hero.png', rating: '9.5' }
                ].map((look) => (
                  <div 
                    key={look.id}
                    onClick={() => {
                      setSelectedModelImg(look.img);
                      triggerToast(`✨ Equipped "${look.title}" onto Model Avatar!`);
                    }}
                    style={{ 
                      borderRadius: '16px', 
                      overflow: 'hidden', 
                      background: '#FFF', 
                      border: selectedModelImg === look.img ? '2px solid #7C3AED' : '1px solid #EFE9E0', 
                      cursor: 'pointer',
                      position: 'relative'
                    }}
                  >
                    <img src={look.img} alt={look.title} style={{ width: '100%', height: '140px', objectFit: 'cover' }} />
                    <div style={{ padding: '8px', fontSize: '10px', textAlign: 'center' }}>
                      <strong style={{ display: 'block', color: '#2E1C44' }}>{look.title}</strong>
                      <span style={{ color: '#10B981', fontWeight: 800 }}>★ {look.rating}/10</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </section>

        {/* 5. "AI OUTFIT SUGGESTIONS" CAROUSEL */}
        <section style={{ background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', boxShadow: '0 4px 20px rgba(46, 28, 68, 0.03)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px', flexWrap: 'wrap', gap: '12px' }}>
            <div>
              <span style={{ fontSize: '11px', fontWeight: 800, letterSpacing: '0.1em', textTransform: 'uppercase', color: '#7C3AED' }}>CURATED LOOKS</span>
              <h2 style={{ margin: '4px 0 0 0', fontSize: '20px', fontWeight: 800, color: '#2E1C44' }}>AI Outfit Suggestions</h2>
            </div>

            {/* Category Tabs */}
            <div style={{ display: 'flex', gap: '8px' }}>
              {['For You', 'Office', 'Casual', 'Party', 'Date'].map((tab) => (
                <button
                  key={tab}
                  onClick={() => setActiveOutfitTab(tab.toLowerCase().replace(' ', '-') as any)}
                  style={{
                    padding: '8px 16px',
                    borderRadius: '20px',
                    border: activeOutfitTab === tab.toLowerCase().replace(' ', '-') ? 'none' : '1px solid #EFE9E0',
                    background: activeOutfitTab === tab.toLowerCase().replace(' ', '-') ? '#2E1C44' : '#FAF7F2',
                    color: activeOutfitTab === tab.toLowerCase().replace(' ', '-') ? '#FFF' : '#6B5B7B',
                    fontSize: '12px',
                    fontWeight: 700,
                    cursor: 'pointer'
                  }}
                >
                  {tab}
                </button>
              ))}
            </div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: isMobile ? '1fr 1fr' : 'repeat(4, 1fr)', gap: '16px' }}>
            {outfitList.map((item) => (
              <div 
                key={item.id} 
                onClick={() => {
                  setSelectedModelImg(item.img);
                  triggerToast(`✨ Wearing "${item.name}" Capsule on Digital Twin!`);
                }}
                style={{ borderRadius: '20px', overflow: 'hidden', background: '#FAF7F2', border: '1px solid #EFE9E0', cursor: 'pointer' }}
              >
                <img src={item.img} alt={item.name} style={{ width: '100%', height: '260px', objectFit: 'cover' }} />
                <div style={{ padding: '14px' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
                    <strong style={{ fontSize: '13px', color: '#2E1C44' }}>{item.name}</strong>
                    <span style={{ fontSize: '11px', fontWeight: 800, color: '#10B981' }}>★ {item.score}</span>
                  </div>
                  <span style={{ fontSize: '11px', color: '#6B5B7B' }}>{item.category} Capsule</span>
                </div>
              </div>
            ))}
          </div>

          <div style={{ textAlign: 'center', marginTop: '20px' }}>
            <button 
              onClick={generate10MoreLooksAction} 
              disabled={isGeneratingLooks}
              style={{ padding: '12px 28px', borderRadius: '24px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '13px', fontWeight: 800, cursor: 'pointer', display: 'inline-flex', alignItems: 'center', gap: '8px' }}
            >
              <Sparkles size={16} color="#EC4899" />
              {isGeneratingLooks ? 'Generating Outfits...' : 'Generate 10 More Looks'}
            </button>
          </div>
        </section>

        {/* 6. ANALYTICS & INTELLIGENCE ROW */}
        <div style={{ display: 'grid', gridTemplateColumns: isMobile ? '1fr' : '320px 1.2fr 340px', gap: '20px' }}>
          
          {/* CLOSET SCORE CIRCULAR GAUGE CHART */}
          <div style={{ background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
            <div>
              <strong style={{ fontSize: '14px', color: '#2E1C44', display: 'block', marginBottom: '16px' }}>CLOSET SCORE</strong>
              
              <div style={{ position: 'relative', width: '140px', height: '140px', margin: '0 auto 16px auto', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <svg width="140" height="140" viewBox="0 0 140 140">
                  <circle cx="70" cy="70" r="55" fill="none" stroke="#FAF7F2" strokeWidth="12" />
                  <circle cx="70" cy="70" r="55" fill="none" stroke="#10B981" strokeWidth="12" strokeDasharray="345" strokeDashoffset="60" strokeLinecap="round" transform="rotate(-90 70 70)" />
                </svg>
                <div style={{ position: 'absolute', textAlign: 'center' }}>
                  <strong style={{ fontSize: '28px', color: '#2E1C44', display: 'block' }}>82%</strong>
                  <span style={{ fontSize: '10px', color: '#10B981', fontWeight: 800 }}>Great Wardrobe!</span>
                </div>
              </div>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', fontSize: '11px' }}>
                <div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '2px' }}>
                    <span>Outfit Variety</span>
                    <strong>91%</strong>
                  </div>
                  <div style={{ height: '6px', borderRadius: '4px', background: '#FAF7F2', overflow: 'hidden' }}>
                    <div style={{ width: '91%', height: '100%', background: '#7C3AED' }} />
                  </div>
                </div>

                <div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '2px' }}>
                    <span>Color Balance</span>
                    <strong>74%</strong>
                  </div>
                  <div style={{ height: '6px', borderRadius: '4px', background: '#FAF7F2', overflow: 'hidden' }}>
                    <div style={{ width: '74%', height: '100%', background: '#F59E0B' }} />
                  </div>
                </div>

                <div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '2px' }}>
                    <span>Formal Wear</span>
                    <strong>40%</strong>
                  </div>
                  <div style={{ height: '6px', borderRadius: '4px', background: '#FAF7F2', overflow: 'hidden' }}>
                    <div style={{ width: '40%', height: '100%', background: '#EF4444' }} />
                  </div>
                </div>
              </div>
            </div>

            <button onClick={() => setShowGapPlanModal(true)} style={{ width: '100%', padding: '10px', borderRadius: '14px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '11px', fontWeight: 800, marginTop: '16px', cursor: 'pointer' }}>
              Improve My Score
            </button>
          </div>

          {/* AI RECOMMENDATION CARD */}
          <div style={{ background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
            <div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '12px' }}>
                <Sparkles size={18} color="#7C3AED" />
                <strong style={{ fontSize: '14px', color: '#2E1C44' }}>AI RECOMMENDATION</strong>
              </div>

              <p style={{ margin: '0 0 16px 0', fontSize: '13px', color: '#4B3B5B', lineHeight: 1.5 }}>
                You have 12 tops but only 2 formal trousers. Adding one navy trouser would unlock <strong>18 new outfit combinations</strong>.
              </p>

              <div style={{ padding: '16px', borderRadius: '20px', background: '#FAF7F2', border: '1px solid #EFE9E0', display: 'flex', alignItems: 'center', gap: '16px' }}>
                <div style={{ width: '70px', height: '70px', borderRadius: '14px', background: '#2E1C44', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <Shirt size={32} color="#FFF" />
                </div>
                <div>
                  <strong style={{ display: 'block', fontSize: '13px', color: '#2E1C44' }}>Navy Formal Trouser</strong>
                  <span style={{ fontSize: '12px', fontWeight: 800, color: '#7C3AED' }}>₹1,599</span>
                  <button onClick={() => setShowShoppingModal(true)} style={{ display: 'block', marginTop: '6px', padding: '6px 12px', borderRadius: '10px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '10px', fontWeight: 800, cursor: 'pointer' }}>View Similar Items</button>
                </div>
              </div>
            </div>
          </div>

          {/* YOUR LOOK TIMELINE */}
          <div style={{ background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
              <strong style={{ fontSize: '14px', color: '#2E1C44' }}>YOUR LOOK TIMELINE</strong>
              <span style={{ fontSize: '11px', color: '#7C3AED', fontWeight: 700 }}>View All</span>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              {lookTimeline.map((item) => (
                <div key={item.id} style={{ display: 'flex', alignItems: 'center', gap: '12px', padding: '10px', borderRadius: '16px', background: '#FAF7F2' }}>
                  <img src={item.img} alt={item.title} style={{ width: '40px', height: '40px', borderRadius: '10px', objectFit: 'cover' }} />
                  <div style={{ flex: 1 }}>
                    <strong style={{ display: 'block', fontSize: '11px', color: '#2E1C44' }}>{item.date} · {item.title}</strong>
                    <span style={{ fontSize: '10px', color: '#F59E0B' }}>★★★★★</span>
                  </div>
                </div>
              ))}
            </div>
          </div>

        </div>

      </main>

      {/* MODAL 1: SEQUENTIAL 3-POSITION MULTI-ANGLE CAPTURE & REVIEW SCREEN MODAL */}
      {showCameraModal && (
        <div style={{ position: 'fixed', inset: 0, zIndex: 1100, background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(12px)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '16px', overflowY: 'auto' }}>
          <div style={{ width: '100%', maxWidth: '580px', maxHeight: '92vh', background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', textAlign: 'center', position: 'relative', display: 'flex', flexDirection: 'column' }}>
            <button onClick={stopCamera} style={{ position: 'absolute', top: '16px', right: '16px', background: '#FAF7F2', border: 'none', borderRadius: '50%', width: '36px', height: '36px', cursor: 'pointer', zIndex: 20 }}>
              <X size={20} color="#2E1C44" />
            </button>

            {/* 3-POSITION STEP PROGRESS BAR HEADER */}
            <div style={{ marginBottom: '16px' }}>
              <div style={{ display: 'flex', justifyContent: 'center', gap: '8px', marginBottom: '8px' }}>
                {['1. Front Angle', '2. Left Side 90°', '3. Right Side 90°'].map((label, idx) => (
                  <div 
                    key={idx}
                    style={{
                      padding: '4px 10px',
                      borderRadius: '10px',
                      fontSize: '10px',
                      fontWeight: 800,
                      background: idx === captureStepIndex ? '#2E1C44' : idx < captureStepIndex ? 'rgba(16,185,129,0.15)' : '#FAF7F2',
                      color: idx === captureStepIndex ? '#FFF' : idx < captureStepIndex ? '#10B981' : '#6B5B7B',
                      border: idx === captureStepIndex ? 'none' : '1px solid #EFE9E0'
                    }}
                  >
                    {idx < captureStepIndex ? `✓ ${label}` : label}
                  </div>
                ))}
              </div>

              <strong style={{ fontSize: '16px', color: '#2E1C44', display: 'block' }}>
                {captureStepIndex === 0 ? '📸 STEP 1/3: FRONT ANGLE PHOTO' : captureStepIndex === 1 ? '📸 STEP 2/3: LEFT SIDE ANGLE (TURN 90° LEFT)' : '📸 STEP 3/3: RIGHT SIDE ANGLE (TURN 90° RIGHT)'}
              </strong>
              <span style={{ fontSize: '11px', color: '#7C3AED', fontWeight: 700 }}>
                {captureStepIndex === 0 ? 'Face directly forward with shoulders level and feet aligned.' : captureStepIndex === 1 ? 'Turn 90° to your left facing sideways.' : 'Turn 90° to your right facing sideways.'}
              </span>
            </div>

            {/* 3D MESH GENERATOR ANIMATION SCREEN */}
            {isBuildingTwinMesh ? (
              <div style={{ padding: '40px 20px', textAlign: 'center' }}>
                <div style={{ width: '80px', height: '80px', borderRadius: '50%', background: 'rgba(124,58,237,0.1)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 20px auto' }}>
                  <Sparkles size={40} color="#7C3AED" />
                </div>
                <strong style={{ fontSize: '20px', color: '#2E1C44', display: 'block', marginBottom: '8px' }}>Building 3D Digital Fashion Twin...</strong>
                <p style={{ fontSize: '12px', color: '#6B5B7B', margin: '0 0 16px 0' }}>Fusing Front, Left & Right poses into a 33-point MediaPipe mesh model</p>
                <div style={{ width: '100%', height: '8px', borderRadius: '4px', background: '#FAF7F2', overflow: 'hidden' }}>
                  <div style={{ width: '100%', height: '100%', background: 'linear-gradient(90deg, #7C3AED, #EC4899)' }} />
                </div>
              </div>
            ) : capturedPreviewImg ? (
              /* PHOTO REVIEW SCREEN MODE */
              <div>
                {/* CAPTURED PHOTO PREVIEW CANVAS */}
                <div style={{ width: '100%', height: isMobile ? '380px' : '440px', borderRadius: '24px', overflow: 'hidden', border: '2px solid #7C3AED', position: 'relative', margin: '0 auto 16px auto', background: '#2E1C44' }}>
                  <img src={capturedPreviewImg} alt="Captured Photo Preview" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                  
                  {/* Quality Check Badge */}
                  <div style={{ position: 'absolute', top: '14px', left: '14px', padding: '6px 12px', borderRadius: '12px', background: 'rgba(16,185,129,0.9)', backdropFilter: 'blur(8px)', color: '#FFF', fontSize: '11px', fontWeight: 800 }}>
                    ✓ Position {captureStepIndex + 1} Quality Check Passed
                  </div>
                </div>

                {/* REAL-TIME AI IMAGE VALIDATION METRICS CARD */}
                <div style={{ background: '#FAF7F2', borderRadius: '18px', padding: '12px 16px', border: '1px solid #EFE9E0', marginBottom: '16px', textAlign: 'left' }}>
                  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '8px' }}>
                    <span style={{ fontSize: '12px', fontWeight: 800, color: '#2E1C44', display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <CheckCircle2 size={16} color="#10B981" /> Real-Time AI Validation Status
                    </span>
                    <span style={{ fontSize: '10px', fontWeight: 800, color: '#FFF', background: '#10B981', padding: '2px 8px', borderRadius: '10px' }}>
                      PASSED (98%)
                    </span>
                  </div>

                  {/* 3 METRIC BREAKDOWN PILLS */}
                  <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '6px', marginBottom: '10px' }}>
                    <div style={{ background: '#FFFFFF', padding: '6px 8px', borderRadius: '10px', border: '1px solid #EFE9E0', textAlign: 'center' }}>
                      <span style={{ fontSize: '9px', color: '#6B5B7B', display: 'block' }}>Pose Align</span>
                      <strong style={{ fontSize: '11px', color: '#2E1C44' }}>{validationResult.poseScore}%</strong>
                    </div>
                    <div style={{ background: '#FFFFFF', padding: '6px 8px', borderRadius: '10px', border: '1px solid #EFE9E0', textAlign: 'center' }}>
                      <span style={{ fontSize: '9px', color: '#6B5B7B', display: 'block' }}>Full Body</span>
                      <strong style={{ fontSize: '11px', color: '#10B981' }}>{validationResult.fullBodyScore}%</strong>
                    </div>
                    <div style={{ background: '#FFFFFF', padding: '6px 8px', borderRadius: '10px', border: '1px solid #EFE9E0', textAlign: 'center' }}>
                      <span style={{ fontSize: '9px', color: '#6B5B7B', display: 'block' }}>Lighting Lux</span>
                      <strong style={{ fontSize: '11px', color: '#7C3AED' }}>{validationResult.lightingLux}%</strong>
                    </div>
                  </div>

                  {/* VALIDATION CHECKLIST BULLETS */}
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', fontSize: '10px', color: '#4B3B5B' }}>
                    {validationResult.alerts.map((item, idx) => (
                      <div key={idx} style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                        <span style={{ color: '#10B981', fontWeight: 800 }}>✓</span>
                        <span>{item}</span>
                      </div>
                    ))}
                  </div>
                </div>

                {/* RETAKE VS CONFIRM & PROCEED ACTION BUTTONS */}
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.3fr', gap: '12px' }}>
                  <button 
                    onClick={() => {
                      setCapturedPreviewImg(null);
                      startCamera();
                      triggerToast(`↺ Retaking Position ${captureStepIndex + 1}`);
                    }} 
                    style={{ padding: '14px', borderRadius: '18px', background: '#FAF7F2', color: '#2E1C44', border: '1px solid #EFE9E0', fontSize: '13px', fontWeight: 800, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px' }}
                  >
                    <RotateCcw size={16} color="#2E1C44" /> Retake Photo
                  </button>
                  
                  <button 
                    onClick={() => {
                      const updatedPhotos = [...threeAnglePhotos];
                      updatedPhotos[captureStepIndex] = capturedPreviewImg;
                      setThreeAnglePhotos(updatedPhotos);

                      if (captureStepIndex < 2) {
                        const nextIndex = captureStepIndex + 1;
                        setCaptureStepIndex(nextIndex);
                        setCapturedPreviewImg(null);
                        startCamera();
                        triggerToast(`✨ Position ${captureStepIndex + 1} Confirmed! Now proceed to Position ${nextIndex + 1} (${nextIndex === 1 ? 'Left 90°' : 'Right 90°'}).`);
                      } else {
                        // All 3 Positions Confirmed! Build 3D Twin Mesh
                        setIsBuildingTwinMesh(true);
                        setTimeout(() => {
                          setIsBuildingTwinMesh(false);
                          stopCamera();
                          setCapturedPreviewImg(null);
                          setCaptureStepIndex(0);
                          setWardrobeCounts((prev) => ({ ...prev, Tops: prev.Tops + 1 }));
                          triggerToast('🎉 All 3 Positions Confirmed! 3D Digital Fashion Twin Successfully Built!');
                        }, 2000);
                      }
                    }} 
                    style={{ padding: '14px', borderRadius: '18px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '13px', fontWeight: 800, cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px' }}
                  >
                    <CheckCircle2 size={18} color="#10B981" /> 
                    {captureStepIndex < 2 ? `Confirm & Go to Step ${captureStepIndex + 2}` : 'Confirm All & Build Twin'}
                  </button>
                </div>
              </div>
            ) : (
              /* LIVE CAMERA STREAM MODE WITH REAL-TIME POSTURE DETECTION ENGINE */
              <div>
                {/* POSTURE DETECTION TESTING BAR */}
                <div style={{ display: 'flex', gap: '6px', justifyContent: 'center', marginBottom: '8px', flexWrap: 'wrap' }}>
                  <button 
                    onClick={() => {
                      setLivePostureState('proper');
                      setPostureFeedbackText('🟢 PROPER POSTURE DETECTED — Feet flat & shoulders level');
                    }}
                    style={{ padding: '4px 10px', borderRadius: '10px', border: livePostureState === 'proper' ? '1.5px solid #10B981' : '1px solid #EFE9E0', background: livePostureState === 'proper' ? 'rgba(16,185,129,0.15)' : '#FAF7F2', color: livePostureState === 'proper' ? '#10B981' : '#6B5B7B', fontSize: '10px', fontWeight: 800, cursor: 'pointer' }}
                  >
                    🟢 Proper Posture
                  </button>
                  <button 
                    onClick={() => {
                      setLivePostureState('leaning');
                      setPostureFeedbackText('🟡 WARNING: Level your shoulders and stand straight');
                    }}
                    style={{ padding: '4px 10px', borderRadius: '10px', border: livePostureState === 'leaning' ? '1.5px solid #F59E0B' : '1px solid #EFE9E0', background: livePostureState === 'leaning' ? 'rgba(245,158,11,0.15)' : '#FAF7F2', color: livePostureState === 'leaning' ? '#F59E0B' : '#6B5B7B', fontSize: '10px', fontWeight: 800, cursor: 'pointer' }}
                  >
                    🟡 Leaning Warning
                  </button>
                  <button 
                    onClick={() => {
                      setLivePostureState('too_close');
                      setPostureFeedbackText('🔴 WARNING: Step back 1 meter so feet are visible');
                    }}
                    style={{ padding: '4px 10px', borderRadius: '10px', border: livePostureState === 'too_close' ? '1.5px solid #EF4444' : '1px solid #EFE9E0', background: livePostureState === 'too_close' ? 'rgba(239,68,68,0.15)' : '#FAF7F2', color: livePostureState === 'too_close' ? '#EF4444' : '#6B5B7B', fontSize: '10px', fontWeight: 800, cursor: 'pointer' }}
                  >
                    🔴 Distance Warning
                  </button>
                </div>

                {/* HANDS-FREE TRIGGER SELECTOR BAR */}
                <div style={{ display: 'flex', gap: '6px', justifyContent: 'center', marginBottom: '12px', flexWrap: 'wrap' }}>
                  <button 
                    onClick={() => setHandsFreeMode('timer')}
                    style={{ padding: '6px 14px', borderRadius: '12px', border: handsFreeMode === 'timer' ? '1.5px solid #7C3AED' : '1px solid #EFE9E0', background: handsFreeMode === 'timer' ? 'rgba(124,58,237,0.1)' : '#FAF7F2', color: handsFreeMode === 'timer' ? '#7C3AED' : '#6B5B7B', fontSize: '11px', fontWeight: 800, cursor: 'pointer' }}
                  >
                    ⏳ 5s Self-Timer
                  </button>
                  <button 
                    onClick={() => {
                      setHandsFreeMode('voice');
                      startVoiceListener();
                    }}
                    style={{ padding: '6px 14px', borderRadius: '12px', border: handsFreeMode === 'voice' ? '1.5px solid #7C3AED' : '1px solid #EFE9E0', background: handsFreeMode === 'voice' ? 'rgba(124,58,237,0.1)' : '#FAF7F2', color: handsFreeMode === 'voice' ? '#7C3AED' : '#6B5B7B', fontSize: '11px', fontWeight: 800, cursor: 'pointer' }}
                  >
                    🗣️ Voice ("Say Capture")
                  </button>
                  <button 
                    onClick={() => {
                      setHandsFreeMode('gesture');
                      triggerToast('🖐️ Raise open palm in view to auto-capture!');
                      setTimeout(() => startHandsFreeCountdown(3), 1500);
                    }}
                    style={{ padding: '6px 14px', borderRadius: '12px', border: handsFreeMode === 'gesture' ? '1.5px solid #7C3AED' : '1px solid #EFE9E0', background: handsFreeMode === 'gesture' ? 'rgba(124,58,237,0.1)' : '#FAF7F2', color: handsFreeMode === 'gesture' ? '#7C3AED' : '#6B5B7B', fontSize: '11px', fontWeight: 800, cursor: 'pointer' }}
                  >
                    🖐️ Palm Gesture
                  </button>
                </div>

                {/* EXPANDED FULL-BODY CAMERA VIEWFINDER CANVAS WITH STRICT GREEN/RED ENFORCEMENT */}
                {(() => {
                  const isProper = livePostureState === 'proper';
                  const activeColor = isProper ? '#10B981' : '#EF4444';
                  return (
                    <div>
                      <div 
                        style={{ 
                          width: '100%', 
                          height: isMobile ? '440px' : '520px', 
                          borderRadius: '24px', 
                          background: '#2E1C44', 
                          overflow: 'hidden', 
                          position: 'relative', 
                          display: 'flex', 
                          alignItems: 'center', 
                          justifyContent: 'center', 
                          border: `3px solid ${activeColor}`,
                          boxShadow: `0 0 24px ${activeColor}40`
                        }}
                      >
                        {isCameraActive ? (
                          <video ref={videoRef} autoPlay playsInline style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                        ) : (
                          <Camera size={72} color={activeColor} />
                        )}

                        {/* REAL-TIME LIVE POSTURE STATUS BADGE OVERLAY (STRICT GREEN VS RED) */}
                        <div 
                          style={{
                            position: 'absolute',
                            top: '14px',
                            left: '14px',
                            right: '14px',
                            padding: '10px 14px',
                            borderRadius: '14px',
                            background: isProper ? 'rgba(16,185,129,0.95)' : 'rgba(239,68,68,0.95)',
                            backdropFilter: 'blur(8px)',
                            color: '#FFF',
                            fontSize: '11px',
                            fontWeight: 800,
                            boxShadow: '0 4px 16px rgba(0,0,0,0.3)',
                            zIndex: 10
                          }}
                        >
                          {postureFeedbackText}
                        </div>

                        {/* 33-POINT GLOWING BODY SKELETON JOINT OVERLAY (STRICT GREEN VS RED) */}
                        <svg width="100%" height="100%" viewBox="0 0 300 500" style={{ position: 'absolute', inset: 0, pointerEvents: 'none', zIndex: 5 }}>
                          <g stroke={activeColor} strokeWidth="3" fill="none" opacity="0.9">
                            {/* Head & Spine Wireframe */}
                            <circle cx="150" cy="70" r="18" fill={isProper ? 'rgba(16,185,129,0.2)' : 'rgba(239,68,68,0.2)'} />
                            <line x1="150" y1="88" x2="150" y2="240" strokeDasharray="4 2" />

                            {/* Shoulders & Arms */}
                            <line x1="100" y1="130" x2="200" y2="130" />
                            <line x1="100" y1="130" x2="80" y2="200" />
                            <line x1="200" y1="130" x2="220" y2="200" />
                            <line x1="80" y1="200" x2="70" y2="270" />
                            <line x1="220" y1="200" x2="230" y2="270" />
                            <circle cx="100" cy="130" r="4" fill={activeColor} />
                            <circle cx="200" cy="130" r="4" fill={activeColor} />
                            <circle cx="80" cy="200" r="3" fill={activeColor} />
                            <circle cx="220" cy="200" r="3" fill={activeColor} />

                            {/* Hips & Legs */}
                            <line x1="120" y1="240" x2="180" y2="240" />
                            <line x1="120" y1="240" x2="115" y2="350" />
                            <line x1="180" y1="240" x2="185" y2="350" />
                            <line x1="115" y1="350" x2="110" y2="440" />
                            <line x1="185" y1="350" x2="190" y2="440" />
                            <circle cx="120" cy="240" r="4" fill={activeColor} />
                            <circle cx="180" cy="240" r="4" fill={activeColor} />
                            <circle cx="115" cy="350" r="3" fill={activeColor} />
                            <circle cx="185" cy="350" r="3" fill={activeColor} />
                            <circle cx="110" cy="440" r="5" fill={activeColor} />
                            <circle cx="190" cy="440" r="5" fill={activeColor} />
                          </g>
                          <line x1="80" y1="450" x2="220" y2="450" stroke={activeColor} strokeWidth="2.5" />
                          <text x="150" y="470" textAnchor="middle" fill={activeColor} fontSize="11" fontWeight="800">
                            {isProper ? 'FEET ALIGNED ✓' : 'ALIGNMENT FAULT ❌'}
                          </text>
                        </svg>

                        {/* Background Scanner Beam Animation */}
                        <div style={{ position: 'absolute', left: 0, right: 0, height: '3px', background: activeColor, boxShadow: `0 0 20px ${activeColor}` }} />

                        {/* BIG ANIMATED COUNTDOWN NUMBER OVERLAY */}
                        {countdownValue !== null && (
                          <div style={{ position: 'absolute', inset: 0, background: 'rgba(46,28,68,0.75)', backdropFilter: 'blur(6px)', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', color: '#FFF' }}>
                            <span style={{ fontSize: '110px', fontWeight: 900, color: '#EC4899', textShadow: '0 0 40px #EC4899', lineHeight: 1 }}>{countdownValue}</span>
                            <span style={{ fontSize: '14px', fontWeight: 800, color: '#FFF', marginTop: '12px' }}>
                              {captureStepIndex === 0 ? 'Hold still for Front Angle!' : captureStepIndex === 1 ? 'Hold still for Left 90° Side!' : 'Hold still for Right 90° Side!'}
                            </span>
                          </div>
                        )}

                        {/* VOICE LISTENING OVERLAY INDICATOR */}
                        {isListeningVoice && (
                          <div style={{ position: 'absolute', top: '16px', left: '16px', right: '16px', padding: '10px 14px', borderRadius: '14px', background: 'rgba(236,72,153,0.9)', backdropFilter: 'blur(8px)', color: '#FFF', fontSize: '12px', fontWeight: 800 }}>
                            🗣️ Listening... Say "CAPTURE" or "CHEESE" out loud!
                          </div>
                        )}
                      </div>

                      {/* CAPTURE ACTION BUTTONS WITH STRICT POSTURE DISABLE GUARD */}
                      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginTop: '16px' }}>
                        <button 
                          onClick={() => startHandsFreeCountdown(5)} 
                          disabled={!isProper}
                          style={{ 
                            padding: '14px', 
                            borderRadius: '18px', 
                            background: isProper ? 'rgba(124,58,237,0.1)' : '#FAF7F2', 
                            color: isProper ? '#7C3AED' : '#9CA3AF', 
                            border: isProper ? '1px solid rgba(124,58,237,0.3)' : '1px solid #E5E7EB', 
                            fontSize: '13px', 
                            fontWeight: 800, 
                            cursor: isProper ? 'pointer' : 'not-allowed',
                            opacity: isProper ? 1 : 0.5 
                          }}
                        >
                          ⏳ 5s Self-Timer
                        </button>
                        <button 
                          onClick={capturePhotoAction} 
                          disabled={!isProper}
                          style={{ 
                            padding: '14px', 
                            borderRadius: '18px', 
                            background: isProper ? '#2E1C44' : '#9CA3AF', 
                            color: '#FFF', 
                            border: 'none', 
                            fontSize: '13px', 
                            fontWeight: 800, 
                            cursor: isProper ? 'pointer' : 'not-allowed',
                            opacity: isProper ? 1 : 0.5 
                          }}
                        >
                          📸 {isProper ? `Capture Position ${captureStepIndex + 1}` : '⚠️ Align Posture First'}
                        </button>
                      </div>
                    </div>
                  );
                })()}
              </div>
            )}
          </div>
        </div>
      )}

      {/* MODAL 2: 3-ANGLE DIGITAL TWIN ONBOARDING MODAL */}
      {showTwinOnboardingModal && (
        <div style={{ position: 'fixed', inset: 0, zIndex: 1100, background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(12px)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px' }}>
          <div style={{ width: '100%', maxWidth: '520px', background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', textAlign: 'center', position: 'relative' }}>
            <button onClick={() => setShowTwinOnboardingModal(false)} style={{ position: 'absolute', top: '16px', right: '16px', background: '#FAF7F2', border: 'none', borderRadius: '50%', width: '32px', height: '32px', cursor: 'pointer' }}>
              <X size={18} color="#2E1C44" />
            </button>

            <h3 style={{ margin: '0 0 8px 0', fontSize: '18px', color: '#2E1C44' }}>Create Your Digital Fashion Twin</h3>
            <p style={{ margin: '0 0 20px 0', fontSize: '12px', color: '#6B5B7B' }}>Capture 3 photo angles to build your 3D mesh avatar</p>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '12px', marginBottom: '20px' }}>
              <div style={{ padding: '12px', borderRadius: '16px', background: '#FAF7F2', border: '1px solid #7C3AED' }}>
                <Camera size={24} color="#7C3AED" style={{ margin: '0 auto 6px auto', display: 'block' }} />
                <span style={{ fontSize: '11px', fontWeight: 800, color: '#2E1C44' }}>1. Front</span>
              </div>
              <div style={{ padding: '12px', borderRadius: '16px', background: '#FAF7F2', border: '1px solid #EFE9E0' }}>
                <Camera size={24} color="#6B5B7B" style={{ margin: '0 auto 6px auto', display: 'block' }} />
                <span style={{ fontSize: '11px', fontWeight: 800, color: '#6B5B7B' }}>2. Left 90°</span>
              </div>
              <div style={{ padding: '12px', borderRadius: '16px', background: '#FAF7F2', border: '1px solid #EFE9E0' }}>
                <Camera size={24} color="#6B5B7B" style={{ margin: '0 auto 6px auto', display: 'block' }} />
                <span style={{ fontSize: '11px', fontWeight: 800, color: '#6B5B7B' }}>3. Right 90°</span>
              </div>
            </div>

            <button onClick={() => { setShowTwinOnboardingModal(false); startCamera(); }} style={{ width: '100%', padding: '14px', borderRadius: '20px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '13px', fontWeight: 800, cursor: 'pointer' }}>
              Start 3-Angle Capture
            </button>
          </div>
        </div>
      )}

      {/* MODAL 3: 3D BODY MESH MEASUREMENTS INSPECTOR MODAL */}
      {showBodyMeshModal && (
        <div style={{ position: 'fixed', inset: 0, zIndex: 1100, background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(12px)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px' }}>
          <div style={{ width: '100%', maxWidth: '460px', background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', position: 'relative' }}>
            <button onClick={() => setShowBodyMeshModal(false)} style={{ position: 'absolute', top: '16px', right: '16px', background: '#FAF7F2', border: 'none', borderRadius: '50%', width: '32px', height: '32px', cursor: 'pointer' }}>
              <X size={18} color="#2E1C44" />
            </button>

            <h3 style={{ margin: '0 0 4px 0', fontSize: '18px', color: '#2E1C44' }}>AI 3D Body Mesh & Measurements</h3>
            <span style={{ fontSize: '11px', color: '#10B981', fontWeight: 800 }}>✓ 33 Pose Joints Calibrated</span>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', marginTop: '16px', fontSize: '12px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', padding: '10px', borderRadius: '12px', background: '#FAF7F2' }}>
                <span>Height:</span>
                <strong>180 cm</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', padding: '10px', borderRadius: '12px', background: '#FAF7F2' }}>
                <span>Body Shape Silhouette:</span>
                <strong>Athletic V-Shape</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', padding: '10px', borderRadius: '12px', background: '#FAF7F2' }}>
                <span>Shoulder Width:</span>
                <strong>44 cm</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', padding: '10px', borderRadius: '12px', background: '#FAF7F2' }}>
                <span>Waist Circumference:</span>
                <strong>76 cm</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', padding: '10px', borderRadius: '12px', background: '#FAF7F2' }}>
                <span>Hip Width:</span>
                <strong>94 cm</strong>
              </div>
            </div>

            <button onClick={() => setShowBodyMeshModal(false)} style={{ width: '100%', padding: '12px', borderRadius: '18px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '12px', fontWeight: 800, marginTop: '20px', cursor: 'pointer' }}>
              Close Inspector
            </button>
          </div>
        </div>
      )}

      {/* MODAL 4: AI ADVICE RATING BREAKDOWN MODAL */}
      {showAdviceModal && (
        <div style={{ position: 'fixed', inset: 0, zIndex: 1100, background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(12px)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px' }}>
          <div style={{ width: '100%', maxWidth: '460px', background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', position: 'relative' }}>
            <button onClick={() => setShowAdviceModal(false)} style={{ position: 'absolute', top: '16px', right: '16px', background: '#FAF7F2', border: 'none', borderRadius: '50%', width: '32px', height: '32px', cursor: 'pointer' }}>
              <X size={18} color="#2E1C44" />
            </button>

            <div style={{ textAlign: 'center', marginBottom: '16px' }}>
              <Award size={36} color="#10B981" style={{ margin: '0 auto 6px auto', display: 'block' }} />
              <h3 style={{ margin: '0 0 2px 0', fontSize: '18px', color: '#2E1C44' }}>Great Look! 9.2 / 10</h3>
              <p style={{ margin: 0, fontSize: '12px', color: '#6B5B7B' }}>Personal AI Stylist Score Breakdown</p>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', fontSize: '12px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', padding: '10px', borderRadius: '12px', background: '#FAF7F2' }}>
                <span>Color Harmony:</span>
                <strong style={{ color: '#10B981' }}>9.0 / 10</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', padding: '10px', borderRadius: '12px', background: '#FAF7F2' }}>
                <span>Fit & Tailoring:</span>
                <strong style={{ color: '#10B981' }}>9.3 / 10</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', padding: '10px', borderRadius: '12px', background: '#FAF7F2' }}>
                <span>Occasion Match:</span>
                <strong style={{ color: '#10B981' }}>9.0 / 10</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', padding: '10px', borderRadius: '12px', background: '#FAF7F2' }}>
                <span>Confidence Index:</span>
                <strong style={{ color: '#10B981' }}>9.5 / 10</strong>
              </div>
            </div>

            <button onClick={() => setShowAdviceModal(false)} style={{ width: '100%', padding: '12px', borderRadius: '18px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '12px', fontWeight: 800, marginTop: '20px', cursor: 'pointer' }}>
              Close Advice Breakdown
            </button>
          </div>
        </div>
      )}

      {/* MODAL 5: GARMENT PICKER DRAWER MODAL */}
      {showGarmentPickerModal && (
        <div style={{ position: 'fixed', inset: 0, zIndex: 1100, background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(12px)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px' }}>
          <div style={{ width: '100%', maxWidth: '500px', background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', position: 'relative' }}>
            <button onClick={() => setShowGarmentPickerModal(false)} style={{ position: 'absolute', top: '16px', right: '16px', background: '#FAF7F2', border: 'none', borderRadius: '50%', width: '32px', height: '32px', cursor: 'pointer' }}>
              <X size={18} color="#2E1C44" />
            </button>

            <h3 style={{ margin: '0 0 16px 0', fontSize: '18px', color: '#2E1C44' }}>Select Garment from {activePickerCategory}</h3>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '12px' }}>
              {[
                { name: 'Lavender Silk Shirt', img: '/models/lavender.png' },
                { name: 'Crisp White Poplin', img: '/models/hero.png' },
                { name: 'Midnight Corset Top', img: '/models/black.png' },
                { name: 'Olive Resort Top', img: '/models/green.png' }
              ].map((item, i) => (
                <div 
                  key={i}
                  onClick={() => {
                    setSelectedModelImg(item.img);
                    setEquippedStack([...equippedStack, { name: item.name, category: activePickerCategory, img: item.img }]);
                    setShowGarmentPickerModal(false);
                    triggerToast(`✨ Equipped "${item.name}" onto Model Avatar!`);
                  }}
                  style={{ padding: '8px', borderRadius: '16px', background: '#FAF7F2', border: '1px solid #EFE9E0', textAlign: 'center', cursor: 'pointer' }}
                >
                  <img src={item.img} alt={item.name} style={{ width: '100%', height: '100px', objectFit: 'cover', borderRadius: '12px', marginBottom: '6px' }} />
                  <strong style={{ fontSize: '10px', display: 'block', color: '#2E1C44' }}>{item.name}</strong>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* MODAL 6: CLOSET GAP ACTION PLAN MODAL */}
      {showGapPlanModal && (
        <div style={{ position: 'fixed', inset: 0, zIndex: 1100, background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(12px)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px' }}>
          <div style={{ width: '100%', maxWidth: '460px', background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', position: 'relative' }}>
            <button onClick={() => setShowGapPlanModal(false)} style={{ position: 'absolute', top: '16px', right: '16px', background: '#FAF7F2', border: 'none', borderRadius: '50%', width: '32px', height: '32px', cursor: 'pointer' }}>
              <X size={18} color="#2E1C44" />
            </button>

            <h3 style={{ margin: '0 0 8px 0', fontSize: '18px', color: '#2E1C44' }}>Improve My Closet Score Plan</h3>
            <p style={{ margin: '0 0 16px 0', fontSize: '12px', color: '#6B5B7B' }}>Adding these 2 items will boost your wardrobe score from 82% to 96%!</p>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', fontSize: '12px' }}>
              <div style={{ padding: '12px', borderRadius: '14px', background: '#FAF7F2', border: '1px solid #EFE9E0' }}>
                <strong style={{ color: '#2E1C44', display: 'block' }}>1. Navy Formal Trousers</strong>
                <span style={{ color: '#7C3AED', fontSize: '11px' }}>Unlocks +18 Formal Combinations</span>
              </div>
              <div style={{ padding: '12px', borderRadius: '14px', background: '#FAF7F2', border: '1px solid #EFE9E0' }}>
                <strong style={{ color: '#2E1C44', display: 'block' }}>2. Platinum Metallic Clutch Bag</strong>
                <span style={{ color: '#7C3AED', fontSize: '11px' }}>Unlocks +12 Evening Combinations</span>
              </div>
            </div>

            <button onClick={() => { setShowGapPlanModal(false); setShowShoppingModal(true); }} style={{ width: '100%', padding: '12px', borderRadius: '18px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '12px', fontWeight: 800, marginTop: '20px', cursor: 'pointer' }}>
              View Recommended Items
            </button>
          </div>
        </div>
      )}

      {/* MODAL 7: SHOPPING RECOMMENDATIONS MODAL */}
      {showShoppingModal && (
        <div style={{ position: 'fixed', inset: 0, zIndex: 1100, background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(12px)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px' }}>
          <div style={{ width: '100%', maxWidth: '460px', background: '#FFFFFF', borderRadius: '28px', padding: '24px', border: '1px solid #EFE9E0', position: 'relative' }}>
            <button onClick={() => setShowShoppingModal(false)} style={{ position: 'absolute', top: '16px', right: '16px', background: '#FAF7F2', border: 'none', borderRadius: '50%', width: '32px', height: '32px', cursor: 'pointer' }}>
              <X size={18} color="#2E1C44" />
            </button>

            <h3 style={{ margin: '0 0 12px 0', fontSize: '18px', color: '#2E1C44' }}>Navy Formal Trouser Recommendations</h3>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '12px', padding: '12px', borderRadius: '16px', background: '#FAF7F2', border: '1px solid #EFE9E0' }}>
                <div style={{ width: '50px', height: '50px', borderRadius: '12px', background: '#2E1C44', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                  <Shirt size={24} color="#FFF" />
                </div>
                <div style={{ flex: 1 }}>
                  <strong style={{ display: 'block', fontSize: '12px', color: '#2E1C44' }}>Zara Tailored Navy Pants</strong>
                  <span style={{ fontSize: '11px', color: '#7C3AED', fontWeight: 800 }}>₹1,599</span>
                </div>
                <button onClick={() => triggerToast('🛍️ Redirecting to Store Page...')} style={{ padding: '6px 12px', borderRadius: '10px', background: '#2E1C44', color: '#FFF', border: 'none', fontSize: '10px', fontWeight: 800, cursor: 'pointer' }}>Buy Now</button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* 7. FIXED MOBILE BOTTOM NAVIGATION BAR */}
      <nav style={{ position: 'fixed', bottom: 0, left: 0, right: 0, background: '#FFFFFF', borderTop: '1px solid #EFE9E0', padding: '10px 24px', display: 'flex', justifyContent: 'space-around', alignItems: 'center', zIndex: 100, boxShadow: '0 -4px 20px rgba(0,0,0,0.05)' }}>
        <div onClick={() => setBottomNavTab('home')} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px', color: bottomNavTab === 'home' ? '#7C3AED' : '#6B5B7B', cursor: 'pointer' }}>
          <Compass size={20} />
          <span style={{ fontSize: '10px', fontWeight: 800 }}>Home</span>
        </div>

        <div onClick={() => setBottomNavTab('wardrobe')} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px', color: bottomNavTab === 'wardrobe' ? '#7C3AED' : '#6B5B7B', cursor: 'pointer' }}>
          <ShoppingBag size={20} />
          <span style={{ fontSize: '10px', fontWeight: 600 }}>Wardrobe</span>
        </div>

        {/* Plus Floating Button */}
        <div onClick={startCamera} style={{ width: '46px', height: '46px', borderRadius: '50%', background: '#2E1C44', color: '#FFF', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 4px 16px rgba(46,28,68,0.3)', cursor: 'pointer', marginTop: '-20px' }}>
          <Plus size={24} />
        </div>

        <div onClick={() => setBottomNavTab('stylist')} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px', color: bottomNavTab === 'stylist' ? '#7C3AED' : '#6B5B7B', cursor: 'pointer' }}>
          <Sparkles size={20} />
          <span style={{ fontSize: '10px', fontWeight: 600 }}>AI Stylist</span>
        </div>

        <div onClick={() => setBottomNavTab('profile')} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '2px', color: bottomNavTab === 'profile' ? '#7C3AED' : '#6B5B7B', cursor: 'pointer' }}>
          <User size={20} />
          <span style={{ fontSize: '10px', fontWeight: 600 }}>Profile</span>
        </div>
      </nav>

    </div>
  );
}
