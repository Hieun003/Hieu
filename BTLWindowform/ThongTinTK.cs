using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;

namespace BTLWindowform
{
    public partial class ThongTinTK : Form
    {
        public ThongTinTK(string v)
        {
            InitializeComponent();
            lbMaNV.Text = v;
        }

        private void ThongTinTK_Load(object sender, EventArgs e)
        {
            string contr = ConfigurationManager.ConnectionStrings["QLDT"].ConnectionString;
            string select = "SELECT [Mã nhân viên], [Họ tên],[Giới tính], [Ngày sinh], [Địa chỉ], [SDT] FROM v_NV WHERE [Tài khoản] = '" + lbMaNV.Text + "'";
            using (SqlConnection cnn = new SqlConnection(contr))
            {
                using (SqlCommand cmd = new SqlCommand(select, cnn))
                {
                    cnn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        txtHoTen.Text = reader["Họ tên"].ToString();
                        txtNgaySinh.Text = reader["Ngày sinh"].ToString();
                        txtDiaChi.Text = reader["Địa chỉ"].ToString();
                        txtSDT.Text = reader["SDT"].ToString();
                        txtMaNV.Text = reader["Mã nhân viên"].ToString();
                        if(reader["Giới tính"].ToString() == "Nam")
                        {
                            radioButton1.Checked = true;
                        }
                        else
                        {
                            radioButton2.Checked = true;
                        }
                    }
                    cnn.Close();
                }
            }
            radioButton1.Enabled = false;
            radioButton2.Enabled = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string constr = ConfigurationManager.ConnectionStrings["QLDT"].ConnectionString;
            int iMaNV = Convert.ToInt32(txtMaNV.Text);
            string g;
            if (radioButton1.Checked == true)
            {
                g = "Nam";
            }
            else
            {
                g = "Nữ";
            }
            DateTime ngaysinh = DateTime.ParseExact(txtNgaySinh.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = con.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Connection = con;
                    cmd.CommandText = "procSuaNV";

                    cmd.Parameters.AddWithValue("@idEmployee", iMaNV);
                    cmd.Parameters.AddWithValue("@fullName", txtHoTen.Text);
                    cmd.Parameters.AddWithValue("@gender", g);
                    cmd.Parameters.AddWithValue("@birthday", ngaysinh);
                    cmd.Parameters.AddWithValue("@adress", txtDiaChi.Text);
                    cmd.Parameters.AddWithValue("@phoneNumber", txtSDT.Text);
                    con.Open();
                    DialogResult dg = MessageBox.Show("Bạn có chắc chắn muốn sửa", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                    if (dg == DialogResult.Yes)
                    {
                        int i = cmd.ExecuteNonQuery();
                        if (i > 0)
                        {
                            MessageBox.Show("Sửa thành công ", "Thông báo", MessageBoxButtons.OK);
                        }
                        else
                        {
                            MessageBox.Show("Sửa thất bại ", "Thông báo", MessageBoxButtons.OK);
                        }
                    }
                }
            }
        }
    }
}
