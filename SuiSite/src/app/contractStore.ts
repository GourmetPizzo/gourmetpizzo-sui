const TodayDate = new Date();

export const today = TodayDate.toISOString()
  .split("T")[0]
  .split("-")
  .join("")
  .slice(2);

export const MissionContract = process.env.NEXT_PUBLIC_MOVE_MISSION;
