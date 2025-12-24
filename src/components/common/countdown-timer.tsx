"use client";

import { useState, useEffect, useMemo } from "react";
import { Clock } from "lucide-react";

interface CountdownTimerProps {
  endDate: Date;
  className?: string;
}

export function CountdownTimer({ endDate, className = "" }: CountdownTimerProps) {
  const [now, setNow] = useState(() => Date.now());

  useEffect(() => {
    const timer = setInterval(() => {
      setNow(Date.now());
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  const timeLeft = useMemo(() => {
    const end = endDate.getTime();
    const diff = end - now;

    if (diff <= 0) {
      return { days: 0, hours: 0, minutes: 0, seconds: 0, isEnded: true };
    }

    return {
      days: Math.floor(diff / (1000 * 60 * 60 * 24)),
      hours: Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
      minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
      seconds: Math.floor((diff % (1000 * 60)) / 1000),
      isEnded: false,
    };
  }, [endDate, now]);

  if (timeLeft.isEnded) {
    return <span className="text-red-500 font-medium">Ended</span>;
  }

  return (
    <div className={`flex items-center gap-1 font-medium ${className}`}>
      <Clock className="w-4 h-4" />
      {timeLeft.days > 0 && <span>{timeLeft.days}d</span>}
      <span>{timeLeft.hours}h</span>
      <span>{timeLeft.minutes}m</span>
      <span>{timeLeft.seconds}s</span>
      <span className="text-sm opacity-80">left</span>
    </div>
  );
}
