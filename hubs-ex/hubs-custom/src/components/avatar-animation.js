/**
 * belivvr custom
 * full-body 아바타 애니메이션 작업을 위한 파일
 */
import { paths } from "../systems/userinput/paths";

/**
 * belivvr custom
 * 아바타 애니메이션 명들을 모아놓은 상수 값.
 */
export const ANIMATIONS = {
  IDLE: "Idle",
  WALKING: "Walking",
  WALKING_BACKWARD: "WalkingBackwards",
  WALKING_LEFT: "LeftStrafeWalk",
  WALKING_RIGHT: "RightStrafeWalk",
  RUNNING: "Running",
  RUNNING_BACKWARD: "RunningBackward",
  RUNNING_LEFT: "LeftStrafe",
  RUNNING_RIGHT: "RightStrafe",
  FLYING: "Flying"
};

// @ts-ignore
AFRAME.registerComponent("avatar-animation", {
  animations: null,

  clock: null,
  mixer: null,
  isMe: false,

  /**
   * belivvr custom
   * 각 값이 양수인지 음수인지에 따라
   * 앞으로 걷는지 뒤로 걷는지
   * 왼쪽으로 걷는지 오른쪽으로 걷는지 정해짐
   */
  schema: {
    front: { default: 0 },
    right: { default: 0 }
  },

  init() {
    /**
     * belivvr custom
     * 모바일에서는 nipple-move 이벤트가 트리거 되어서
     * 애니메이션이 작동하게 됨
     */
    document.addEventListener("nipple-move", (e) => {
      const { front, right } = e.detail;
      this.el.setAttribute("avatar-animation", { front, right });
    })

    this.animations = new Map();
    this.mixer = new THREE.AnimationMixer(this.el.object3D?.parent || this.el.object3D);
    this.clock = new THREE.Clock();
    this.userinput = AFRAME.scenes[0].systems.userinput;
    this.isMe = this.el.closest("#avatar-rig") != null;

    this.setAnimations(this.el.object3D);
  },

  /**
   * belivvr custom
   * 1초에 60번 호출되는 함수.
   * 포지션 값을 불러와서 애니메이션을 작동시킨다.
   */
  tick() {
    this.mixer.update(this.clock.getDelta());

    if (this.isMe) {
      const position = this.userinput.get(paths.actions.characterAcceleration);

      if (position) {
        const [right, front] = position;
        this.el.setAttribute("avatar-animation", { front, right });
      }
    }
  },

  /**
   * belivvr custom
   * idle(기본 자세) 일 경우에 단순 return을 하고
   * 아닐 경우에 걷게 한다.
   */
  update() {
    if (this.isIdle()) return this.idle();
    this.walking();
  },

  /**
   * belivvr custom
   * idle 은 기본 애니메이션을 뜻한다.
   * 가만히 서있는 자세를 말함.
   */
  idle() {
    this.resetAll(ANIMATIONS.IDLE);
    this.setEffectiveWeight(ANIMATIONS.IDLE, 1);
  },

  /**
   * belivvr custom
   * 인자로 받은 애니메이션 제외하고 모두 초기화 시킨다
   */
  resetAll(...ignore) {
    this.animations.forEach((animation) => {
      if (ignore.includes(animation.getClip().name)) return;
      animation.setEffectiveWeight(0);
    });
  },

  /**
   * belivvr custom
   * idle 상태인지 확인한다
   */
  isIdle() {
    return this.data.front === 0 && this.data.right === 0;
  },

  /**
   * belivvr custom
   * 걷는 애니메이션 코드이다.
   */
  walking() {
    [
      [ANIMATIONS.WALKING, this.data.front],
      [ANIMATIONS.WALKING_BACKWARD, -this.data.front],
      [ANIMATIONS.WALKING_LEFT, -this.data.right],
      [ANIMATIONS.WALKING_RIGHT, this.data.right],
    ].forEach(([animationName, value]) => this.setEffectiveWeight(animationName, value));
  },

  /**
   * belivvr custom
   * 상수 애니메이션 값들을 초기에 세팅해준다.
   */
  setAnimations(object3D) {
    if (object3D.parent == null) return;
    if (object3D.animations.length === 0)
      return this.setAnimations(object3D.parent);

    object3D.animations.forEach((animation) => {
      this.animations.set(animation.name, this.mixer.clipAction(animation));
      this.animations.get(animation.name).play();
      this.setEffectiveWeight(animation.name, 0);
    });
    this.setEffectiveWeight(ANIMATIONS.IDLE, 1);
  },

  /**
   * belivvr custom
   * weight 값과 애니메이션 이름을 인자로 넣어주어
   * 실제로 애니메이션이 동작하게 한다.
   */
  setEffectiveWeight(animationName, weight) {
    this.animations.get(animationName)?.setEffectiveWeight(weight);
  },
});
