export const generateHtmlWelcome = (username, otp) => {
  return `
      <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
        <link
          href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:ital,wght@0,200..800;1,200..800&display=swap"
          rel="stylesheet"
        />
        <style>
          .dot:after {
            content: "";
            width: 5px;
            height: 5px;
            border-radius: 50%;
            margin: 0 4px;
            background: #7a7a7a;
            display: inline-block;
          }
        </style>
      </head>
      <body>
        <table
          style="
            font-family: 'Plus Jakarta Sans', sans-serif;
            width: 680px;
            height: 680px;
            background-color: white;
            padding: 32px 48px;
            border-radius: 12px;
          "
        >
          <tbody style="width: 100%; height: 100%">
            <tr>
              <td style="text-align: center">
                <img
                  src="https://res.cloudinary.com/dtrtjisrv/image/upload/f_auto,q_auto/v1/logo/iu1leiumuyoyu7qunsrg"
                  alt=""
                  style="max-width: 200px; height: auto; margin: 0 auto"
                />
              </td>
            </tr>
            <tr>
                <td style="text-align: center">
                  <img
                    src="https://res.cloudinary.com/dtrtjisrv/image/upload/f_auto,q_auto/v1/banner/dwvp5langlcr1wcirlbu"
                    alt=""
                    style="width: 600px; height: 300px; margin: 0 auto; border-radius: 20px;"
                  />
                </td>
              </tr>
            <tr>
              <td style="text-align: center; ">
                <h1
                  style="
                    font-size: 24px;
                    font-weight: 700;
                    line-height: 32px;
                    margin: 0px;
                    margin-top: 40px;
                  "
                >
                  Welcome to WordWizard!
                </h1>
              </td>
            </tr>
            <tr>
              <td>
                <h3
                  style="
                    line-height: 28px;
                    font-weight: 700;
                    font-size: 20px;
                    margin: 0px;
                    margin-top: 24px;
                  "
                >
                  Hi ${username},
                </h3>
              </td>
            </tr>
            <tr>
              <td>
                <p
                  style="
                    line-height: 20px;
                    font-weight: 300;
                    font-size: 14px;
                    margin: 0px;
                    margin-top: 24px;
                  "
                >
                  Congratulations! You now have an account on WordWizard! Here is the code to verify your account.
                </p>
              </td>
            </tr>
            <tr>
              <td>
                <h1
                  style="letter-spacing: 20px; font-size: 40px; text-align: center"
                >
                  ${otp}
                </h1>
              </td>
            </tr>
            <tr>
              <td>
                <p
                  style="
                    line-height: 20px;
                    font-weight: 300;
                    font-size: 14px;
                    margin: 0px;
                    margin-top: 24px;
                  "
                >
                    Thank you for choosing WordWizard. We look forward to seeing the amazing content that you will create.
                </p>
              </td>
            </tr>
            <tr>
              <td>
                <p
                  style="
                    line-height: 20px;
                    font-weight: 300;
                    font-size: 14px;
                    margin: 0px;
                    margin-top: 24px;
                    margin-bottom: 24px;
                  "
                >
                  Best Regards,<br />
                  <span style="font-weight: 600; font-size: 14px; color: #121212"
                    >WordWizard team.</span
                  >
                </p>
              </td>
            </tr>
            <tr>
              <td style="background: #e8e6f6d6"></td>
            </tr>
            <tr>
              <td style="text-align: center; vertical-align: middle">
                <span style="margin: 0 8px">
                  <img
                    style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                    src="https://cdn-icons-png.flaticon.com/512/20/20673.png"
                    alt="ICON"
                  />
                </span>
                <span style="margin: 0 8px">
                  <img
                    style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                    src="https://cdn-icons-png.flaticon.com/512/1362/1362894.png"
                    alt="ICON"
                  />
                </span>
                <span style="margin: 0 8px">
                  <img
                    style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                    src="https://cdn-icons-png.flaticon.com/512/25/25231.png"
                    alt="ICON"
                  />
                </span>
              </td>
            </tr>
            <tr>
              <td style="background: #e8e6f6d6"></td>
            </tr>
  
            <tr>
              <td style="text-align: center; vertical-align: middle">
                <p
                  style="
                    margin: 0;
                    margin-top: 16px;
                    font-size: 10px;
                    font-weight: 200;
                    line-height: 12.6px;
                  "
                >
                  © 2024 WordWizard. All rights reserved.
                </p>
              </td>
            </tr>
  
            <tr>
              <td style="text-align: center; vertical-align: middle; width: 476px">
                <p
                  style="
                    margin: 0;
                    margin-top: 24px;
                    font-size: 10px;
                    font-weight: 200;
                    line-height: 16px;
                  "
                >
                  You are receiving this mail because you registered to join the
                  WordWizard platform as a user or a creator. This also shows that
                  you agree to our Terms of use and Privacy Policies. If you no
                  longer want to receive mails from use, click the unsubscribe link
                  below to unsubscribe.
                </p>
              </td>
            </tr>
  
            <tr>
              <td style="text-align: center; vertical-align: middle">
                <a
                  class="dot"
                  style="font-size: 10px; font-weight: 500; line-height: 12.6px"
                >
                  Xuan Binh
                </a>
                <a
                  class="dot"
                  style="font-size: 10px; font-weight: 500; line-height: 12.6px"
                >
                  Mai Duy
                </a>
                
                <a style="font-size: 10px; font-weight: 500; line-height: 12.6px">
                  Cong Hien
                </a>
              </td>
            </tr>
          </tbody>
        </table>
      </body>
    </html>
    `;
};

export const generateHtmlRenew = (username, otp) => {
    return `
        <html lang="en">
        <head>
          <meta charset="UTF-8" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          <title>Document</title>
          <link rel="preconnect" href="https://fonts.googleapis.com" />
          <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
          <link
            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:ital,wght@0,200..800;1,200..800&display=swap"
            rel="stylesheet"
          />
          <style>
            .dot:after {
              content: "";
              width: 5px;
              height: 5px;
              border-radius: 50%;
              margin: 0 4px;
              background: #7a7a7a;
              display: inline-block;
            }
          </style>
        </head>
        <body>
          <table
            style="
              font-family: 'Plus Jakarta Sans', sans-serif;
              width: 680px;
              height: 680px;
              background-color: white;
              padding: 32px 48px;
              border-radius: 12px;
            "
          >
          <tbody style="width: 100%; height: 100%">
          <tr>
            <td style="text-align: center">
              <img
                src="https://res.cloudinary.com/dtrtjisrv/image/upload/f_auto,q_auto/v1/logo/iu1leiumuyoyu7qunsrg"
                alt=""
                style="max-width: 200px; height: auto; margin: 0 auto"
              />
            </td>
          </tr>
         
            <td style="text-align: center; ">
              <h1
                style="
                  font-size: 24px;
                  font-weight: 700;
                  line-height: 32px;
                  margin: 0px;
                  margin-top: 40px;
                "
              >
                Your New OTP!
              </h1>
            </td>
          </tr>
          <tr>
            <td>
              <h3
                style="
                  line-height: 28px;
                  font-weight: 700;
                  font-size: 20px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                Hi ${username},
              </h3>
            </td>
          </tr>
          <tr>
            <td>
              <p
                style="
                  line-height: 20px;
                  font-weight: 300;
                  font-size: 14px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                This is your new OTP to verify your account.
              </p>
            </td>
          </tr>
          <tr>
            <td>
              <h1
                style="letter-spacing: 20px; font-size: 40px; text-align: center"
              >
                ${otp}
              </h1>
            </td>
          </tr>
          <tr>
            <td>
              <p
                style="
                  line-height: 20px;
                  font-weight: 300;
                  font-size: 14px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                  Thank you for choosing WordWizard. We look forward to seeing the amazing content that you will create.
              </p>
            </td>
          </tr>
          <tr>
            <td>
              <p
                style="
                  line-height: 20px;
                  font-weight: 300;
                  font-size: 14px;
                  margin: 0px;
                  margin-top: 24px;
                  margin-bottom: 24px;
                "
              >
                Best Regards,<br />
                <span style="font-weight: 600; font-size: 14px; color: #121212"
                  >WordWizard team.</span
                >
              </p>
            </td>
          </tr>
          <tr>
            <td style="background: #e8e6f6d6"></td>
          </tr>
          <tr>
            <td style="text-align: center; vertical-align: middle">
              <span style="margin: 0 8px">
                <img
                  style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                  src="https://cdn-icons-png.flaticon.com/512/20/20673.png"
                  alt="ICON"
                />
              </span>
              <span style="margin: 0 8px">
                <img
                  style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                  src="https://cdn-icons-png.flaticon.com/512/1362/1362894.png"
                  alt="ICON"
                />
              </span>
              <span style="margin: 0 8px">
                <img
                  style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                  src="https://cdn-icons-png.flaticon.com/512/25/25231.png"
                  alt="ICON"
                />
              </span>
            </td>
          </tr>
          <tr>
            <td style="background: #e8e6f6d6"></td>
          </tr>
  
          <tr>
            <td style="text-align: center; vertical-align: middle">
              <p
                style="
                  margin: 0;
                  margin-top: 16px;
                  font-size: 10px;
                  font-weight: 200;
                  line-height: 12.6px;
                "
              >
                © 2024 WordWizard. All rights reserved.
              </p>
            </td>
          </tr>
  
          <tr>
            <td style="text-align: center; vertical-align: middle; width: 476px">
              <p
                style="
                  margin: 0;
                  margin-top: 24px;
                  font-size: 10px;
                  font-weight: 200;
                  line-height: 16px;
                "
              >
                You are receiving this mail because you registered to join the
                WordWizard platform as a user or a creator. This also shows that
                you agree to our Terms of use and Privacy Policies. If you no
                longer want to receive mails from use, click the unsubscribe link
                below to unsubscribe.
              </p>
            </td>
          </tr>
  
          <tr>
            <td style="text-align: center; vertical-align: middle">
              <a
                class="dot"
                style="font-size: 10px; font-weight: 500; line-height: 12.6px"
              >
                Xuan Binh
              </a>
              <a
                class="dot"
                style="font-size: 10px; font-weight: 500; line-height: 12.6px"
              >
                Mai Duy
              </a>
              
              <a style="font-size: 10px; font-weight: 500; line-height: 12.6px">
                Cong Hien
              </a>
            </td>
          </tr>
        </tbody>
          </table>
        </body>
      </html>
      `;
  };

export const generateHtmlReset = (username, otp) => {
  return `
    <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Document</title>
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
      <link
        href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:ital,wght@0,200..800;1,200..800&display=swap"
        rel="stylesheet"
      />
      <style>
        .dot:after {
          content: "";
          width: 5px;
          height: 5px;
          border-radius: 50%;
          margin: 0 4px;
          background: #7a7a7a;
          display: inline-block;
        }
      </style>
    </head>
    <body>
      <table
        style="
          font-family: 'Plus Jakarta Sans', sans-serif;
          width: 680px;
          height: 680px;
          background-color: white;
          padding: 32px 48px;
        "
      >
        <tbody style="width: 100%; height: 100%">
          <tr>
            <td style="text-align: center">
              <img
                src="https://res.cloudinary.com/dtrtjisrv/image/upload/f_auto,q_auto/v1/logo/iu1leiumuyoyu7qunsrg"
                alt=""
                style="max-width: 200px; height: auto; margin: 0 auto"
              />
            </td>
          </tr>
          <tr>
            <td style="text-align: center">
              <h1
                style="
                  font-size: 24px;
                  font-weight: 700;
                  line-height: 32px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                Reset your password
              </h1>
            </td>
          </tr>
          <tr>
            <td>
              <h3
                style="
                  line-height: 28px;
                  font-weight: 700;
                  font-size: 20px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                Hi ${username},
              </h3>
            </td>
          </tr>
          <tr>
            <td>
              <p
                style="
                  line-height: 20px;
                  font-weight: 300;
                  font-size: 14px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                You have requested us to send a OTP to reset your password for
                your WordWizard account, here it is.
              </p>
            </td>
          </tr>
          <tr>
            <td>
              <h1
              style="letter-spacing: 20px; font-size: 40px; text-align: center">${otp}</h1>
            </td>
          </tr>
          <tr>
            <td>
              <p
                style="
                  line-height: 20px;
                  font-weight: 300;
                  font-size: 14px;
                  margin: 0px;
                  margin-top: 24px;
                "
              >
                If you didn’t initiate the request, you can safely ignore the mail
              </p>
            </td>
          </tr>
          <tr>
            <td>
              <p
                style="
                  line-height: 20px;
                  font-weight: 300;
                  font-size: 14px;
                  margin: 0px;
                  margin-top: 24px;
                  margin-bottom: 24px;
                "
              >
                Best Regards,<br />
                <span style="font-weight: 600; font-size: 14px; color: #121212"
                  >WordWizard team.</span
                >
              </p>
            </td>
          </tr>
          <tr>
            <td style="background: #e8e6f6d6"></td>
          </tr>
          <tr>
            <td style="text-align: center; vertical-align: middle">
              <span style="margin: 0 8px">
                <img
                  style="margin: 8px 0 4px 0; width: 40px; height: 40px;"
                  src="https://cdn-icons-png.flaticon.com/512/20/20673.png"
                  alt="ICON"
                />
              </span>
              <span style="margin: 0 8px">
                <img
                  style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                  src="https://cdn-icons-png.flaticon.com/512/1362/1362894.png"
                  alt="ICON"
                />
              </span>
              <span style="margin: 0 8px">
                <img
                  style="margin: 8px 0 4px 0; width: 40px; height: 40px"
                  src="https://cdn-icons-png.flaticon.com/512/25/25231.png"
                  alt="ICON"
                />
              </span>
            </td>
          </tr>
          <tr>
            <td style="background: #e8e6f6d6"></td>
          </tr>
  
          <tr>
            <td style="text-align: center; vertical-align: middle">
              <p
                style="
                  margin: 0;
                  margin-top: 16px;
                  font-size: 10px;
                  font-weight: 200;
                  line-height: 12.6px;
                "
              >
                © 2024 WordWizard. All rights reserved.
              </p>
            </td>
          </tr>
  
          <tr>
            <td style="text-align: center; vertical-align: middle; width: 476px">
              <p
                style="
                  margin: 0;
                  margin-top: 24px;
                  font-size: 10px;
                  font-weight: 200;
                  line-height: 16px;
                "
              >
                You are receiving this mail because you registered to join the
                WordWizard platform as a user or a creator. This also shows that you
                agree to our Terms of use and Privacy Policies. If you no longer
                want to receive mails from use, click the unsubscribe link below
                to unsubscribe.
              </p>
            </td>
          </tr>
  
          <tr>
          <td style="text-align: center; vertical-align: middle">
          <a
            class="dot"
            style="font-size: 10px; font-weight: 500; line-height: 12.6px"
          >
            Xuan Binh
          </a>
          <a
            class="dot"
            style="font-size: 10px; font-weight: 500; line-height: 12.6px"
          >
            Mai Duy
          </a>
          
          <a style="font-size: 10px; font-weight: 500; line-height: 12.6px">
            Cong Hien
          </a>
        </td>
          </tr>
        </tbody>
      </table>
    </body>
  </html>
    `;
};
